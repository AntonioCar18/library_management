import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IzdavanjeVracanjeKnjige extends StatefulWidget {
  const IzdavanjeVracanjeKnjige({super.key});

  @override
  State<IzdavanjeVracanjeKnjige> createState() => _IzdavanjeVracanjeKnjigeState();
}

class _IzdavanjeVracanjeKnjigeState extends State<IzdavanjeVracanjeKnjige> {
  bool _isHovering = false;
  bool _isHovering1 = false;
  bool _isHovering2 = false;
  bool _isHovering3 = false;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _naslovController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _imeOsobeController = TextEditingController();

  bool _populatedFromArgs = false;
  bool _fieldsAreReadOnly = true;
  bool _fieldsImeReadOnly = true;
  bool _saveediting = false;
  bool _availability = false;

  final String _baseUrl = '6286f066d9d3.ngrok-free.app'; // zamijeni s tvojim ngrokom

  @override
void initState() {
  super.initState();
  _idController.addListener(() {
    _provjeriReadOnlyStatus();
  });
  _provjeriReadOnlyStatus(); // odmah provjeri na početku
}


  void dispose() {
    _idController.dispose();
    _naslovController.dispose();
    _autorController.dispose();
    _imeOsobeController.dispose();
    super.dispose();
  }

  Future<bool> provjeriDostupnostKnjige(String id) async {
    try {
      final uri = Uri.https(_baseUrl, '/library/api/searchId', {'id': id});
      final headers = {'ngrok-skip-browser-warning': 'true'};
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isEmpty) return false;
        return data['availability'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Greška prilikom provjere dostupnosti: $e');
      return false;
    }
  }

  Future<void> _provjeriReadOnlyStatus() async {
    String id = _idController.text.trim();

    if (id.isEmpty) {
      setState(() {
        _fieldsImeReadOnly = false;
        _availability = true; // ako nema ID, polje nije readonly
      });
      return;
    }

    bool dostupna = await provjeriDostupnostKnjige(id);

    setState(() {
      _fieldsImeReadOnly = !dostupna; // ako nije dostupna, ime osobe postaje readonly
      _availability = dostupna;   
    });
  }


  Future<bool> izdajKnjigu(String id, String imeOsobe) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true'
      };
      final Map<String, String> queryParams = {};
      if (id.isNotEmpty && imeOsobe.isNotEmpty) {
        queryParams['id'] = id;
        queryParams['person'] = imeOsobe;
      }
      final uri = Uri.https(_baseUrl, '/library/api/borrow', queryParams);

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Greška pri izdavanju: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Greška u izdavanju knjige: $e');
      return false;
    }
  }

  Future<bool> provjeriPosudenuKnjigu(String id, String naslov, String autor, String imeOsobe) async {
    try {
      final uri = Uri.https(_baseUrl, '/library/api/search', {'id': id, 'title': naslov, 'author': autor});
      final headers = {'ngrok-skip-browser-warning': 'true'};
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isEmpty) return false;
        final knjiga = data[0];
        return knjiga['borrowedBy'] == imeOsobe;
      } else {
        return false;
      }
    } catch (e) {
      print('Greška u provjeri posuđene knjige: $e');
      return false;
    }
  }

  Future<bool> vratiKnjigu(String id) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
      final Map<String, String> queryParams = {};
      if (id.isNotEmpty) {
        queryParams['id'] = id;
      }
      final uri = Uri.https(_baseUrl, '/library/api/returnBook', queryParams);

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Greška pri povratu: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Greška u povratu knjige: $e');
      return false;
    }
  }

  Future<bool> urediSadrzaj(String id, String naslov, String autor, String imeOsobe, bool availability) async {
  try {
    final uri = Uri.https('6286f066d9d3.ngrok-free.app', '/library/api/editBook');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'id': id,
      'title': naslov,
      'author': autor,
      'borrowedBy': imeOsobe,
      'availability': availability,
    });

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Greška pri uređivanju: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    print('Greška prilikom uređivanja knjige: $e');
    return false;
  }
}


  Future<bool> obrisiKnjigu(String id) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
      final Map<String, String> queryParams = {};
      if (id.isNotEmpty) {
        queryParams['id'] = id;
      }
      final uri = Uri.https(_baseUrl, '/library/api/deleteBook', queryParams);

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Greška pri brisanju: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Greška u brisanju knjige: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (!_populatedFromArgs && args != null) {
      _idController.text = args['id']?.toString() ?? '';
      _naslovController.text = args['title'] ?? '';
      _autorController.text = args['author'] ?? '';
      _imeOsobeController.text = args['borrowedBy'] ?? '';
      _availability = args['availability'] ?? false;
      _populatedFromArgs = true;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        backgroundColor: Colors.blue[900],
        title: const Text('Knjižnica Župe Bl. Alojzija Stepinca Duga Resa'),
        foregroundColor: Colors.white,
        actions: [
          const Center(child: Text('Admin', style: TextStyle(color: Colors.white))),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const CircleAvatar(backgroundImage: AssetImage('asset/img1.jpg')),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: constraints.maxHeight,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(25),
                              child: Text('Izdavanje/Povrat/Brisanje knjige', style: TextStyle(fontSize: 25)),
                            ),
                            Divider(height: 5, color: Colors.grey.shade100, thickness: 1),
                            _buildInputRow(
                              icon: Icons.numbers,
                              label: 'ID knjige*',
                              controller: _idController,
                              hintText: 'ID knjige',
                              readOnly: _fieldsAreReadOnly,
                            ),
                            _buildInputRow(
                              icon: Icons.book,
                              label: 'Naslov*',
                              controller: _naslovController,
                              hintText: 'Unesite naslov knjige',
                              readOnly: _fieldsAreReadOnly,
                            ),
                            _buildInputRow(
                              icon: Icons.person,
                              label: 'Autor*',
                              controller: _autorController,
                              hintText: 'Unesite ime i prezime autora knjige',
                              readOnly: _fieldsAreReadOnly,
                            ),
                            _buildInputRow(
                              icon: Icons.person_outline,
                              label: 'Ime osobe*',
                              controller: _imeOsobeController,
                              hintText: 'Unesite ime osobe kojoj se izdaje knjiga',
                              readOnly: _fieldsImeReadOnly,
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 40),
            child: FloatingActionButton.extended(
              heroTag: 'izdavanje',
              onPressed: _handleIzdavanje,
              label: const Text('Izdavanje knjige', style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.book_outlined, color: Colors.white),
              backgroundColor: Colors.blue[900],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 40),
            child: FloatingActionButton.extended(
              heroTag: 'povrat',
              onPressed: _handlePovrat,
              label: const Text('Povrat knjige', style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.keyboard_return, color: Colors.white),
              backgroundColor: Colors.blue[700],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 40),
            child: FloatingActionButton.extended(
              heroTag: 'urediknjigu',
              onPressed: (){
                _handleSadrzaj();
              },
              label: Text(_saveediting ? 'Spremi' :' Uredi detalje', style: TextStyle(color: Colors.white)),
              icon:  Icon(_saveediting ? Icons.save : Icons.edit, color: Colors.white),
              backgroundColor: Colors.blue[700],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 40),
            child: FloatingActionButton.extended(
              heroTag: 'brisanje',
              onPressed: _handleDelete,
              label: const Text('Brisanje knjige', style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.delete, color: Colors.white),
              backgroundColor: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 300,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSidebarItem(
            hovering: _isHovering,
            onEnter: () => setState(() => _isHovering = true),
            onExit: () => setState(() => _isHovering = false),
            icon: Icons.search,
            label: 'Pretraživanje knjige',
            onTap: () => Navigator.pushNamed(context, '/pretrazivanje'),
          ),
          _buildSidebarItem(
            hovering: _isHovering1,
            onEnter: () => setState(() => _isHovering1 = true),
            onExit: () => setState(() => _isHovering1 = false),
            icon: Icons.add,
            label: 'Dodavanje nove knjige',
            onTap: () => Navigator.pushNamed(context, '/upisknjige'),
          ),
          _buildSidebarItem(
            hovering: _isHovering2,
            onEnter: () => setState(() => _isHovering2 = true),
            onExit: () => setState(() => _isHovering2 = false),
            icon: Icons.read_more,
            label: 'Upravljanje knjigom',
            onTap: () => Navigator.pushNamed(context, '/izdavanje_knjige'),
          ),
          _buildSidebarItem(
            hovering: _isHovering3,
            onEnter: () => setState(() => _isHovering3 = true),
            onExit: () => setState(() => _isHovering3 = false),
            icon: Icons.home,
            label: 'Povratak na početnu',
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required bool hovering,
    required VoidCallback onEnter,
    required VoidCallback onExit,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: hovering ? Colors.grey.shade300 : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 15),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool readOnly = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(label, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleIzdavanje() async {
    String id = _idController.text.trim();
    String naslov = _naslovController.text.trim();
    String autor = _autorController.text.trim();
    String imeOsobe = _imeOsobeController.text.trim();

    if (naslov.isEmpty || autor.isEmpty || imeOsobe.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Molimo ispunite sva polja.'), backgroundColor: Colors.red),
      );
            setState(() {
        _fieldsImeReadOnly = true;
      });
      return;
    }

    bool dostupna = await provjeriDostupnostKnjige(id);
    if (!dostupna) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knjiga nije dostupna za izdavanje.'), backgroundColor: Colors.red),
      );
      return;
    }

    bool uspjeh = await izdajKnjigu(id, imeOsobe);
    if (uspjeh) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Knjiga izdana za $imeOsobe!'), backgroundColor: Colors.green),
      );
      _idController.clear();
      _naslovController.clear();
      _autorController.clear();
      _imeOsobeController.clear();
      Navigator.pushNamed(context, '/pretrazivanje');

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Došlo je do greške prilikom izdavanja.'), backgroundColor: Colors.red),
      );
    }
  }

  void _handlePovrat() async {
    String id = _idController.text.trim();
    String naslov = _naslovController.text.trim();
    String autor = _autorController.text.trim();
    String imeOsobe = _imeOsobeController.text.trim();

    if (id.isEmpty || naslov.isEmpty || autor.isEmpty || imeOsobe.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Molimo ispunite sva polja za povrat.'), backgroundColor: Colors.red),
      );
      return;
    }

    bool uspjeh = await vratiKnjigu(id);
    if (uspjeh) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knjiga uspješno vraćena!'), backgroundColor: Colors.green),
      );
      _idController.clear();
      _naslovController.clear();
      _autorController.clear();
      _imeOsobeController.clear();
      Navigator.pushNamed(context, '/pretrazivanje');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Došlo je do greške pri povratu knjige.'), backgroundColor: Colors.red),
      );
    }
  }

  void _handleSadrzaj() async {
  String id = _idController.text.trim();
  String naslov = _naslovController.text.trim();
  String autor = _autorController.text.trim();
  String imeOsobe = _imeOsobeController.text.trim();

  if (!_saveediting) {
    setState(() {
      _saveediting = true;
      _fieldsAreReadOnly = false;
      _fieldsImeReadOnly = _availability;
    });
  } else {
    // Proslijedi i availability
    bool uspjeh = await urediSadrzaj(id, naslov, autor, imeOsobe, _availability);
    if (uspjeh) {
      setState(() {
        _saveediting = false;
        _fieldsAreReadOnly = true;
        _fieldsImeReadOnly = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Detalji knjige uspješno spremljeni.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Greška prilikom spremanja detalja knjige.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  void _handleDelete() async {

    String id = _idController.text.trim();
    bool potvrda = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Center(child: Text('Potvrda brisanja')),
        content: Text('Jeste li sigurni da želite obrisati sadržaj?'),
        actions: [
          FloatingActionButton.extended(
              onPressed: (){
                Navigator.of(context).pop(true);
              },
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
                label: Text(
                  'POTVRDI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(width: 5.0),
            FloatingActionButton.extended(
              onPressed: (){
                Navigator.of(context).pop(false);
              },
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
                label: Text(
                  'ODUSTANI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        ],
      ),
    );

    if(potvrda){
    bool uspjeh = await obrisiKnjigu(id);
    if (uspjeh) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knjiga je uspješno obrisana!'), backgroundColor: Colors.green),
      );
      _idController.clear();
      _naslovController.clear();
      _autorController.clear();
      _imeOsobeController.clear();
      Navigator.pushNamed(context, '/pretrazivanje');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Došlo je do greške prilikom brisanja knjige.'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
