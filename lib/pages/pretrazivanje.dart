import 'dart:convert';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';

class SearchBook extends StatefulWidget {
  const SearchBook({super.key});

  @override
  _SearchBookState createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> {
  bool _isHovering = false;
  bool _isHovering1 = false;
  bool _isHovering2 = false;
  bool _isHovering3 = false;

  String _searchQuery = "";
  List<dynamic> _books = [];

  // Pomoćna funkcija za centriranje DataCell-a sa fiksnom širinom i elipsama za predugi tekst
  DataCell centeredCell(String text, {double width = 100}) {
    return DataCell(
      SizedBox(
        width: width,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  List<dynamic> get _filteredBooks {
    if (_searchQuery.isEmpty) return _books;

    return _books.where((book) {
      final naziv = (book['title'] ?? '').toString().toLowerCase();
      final autor = (book['author'] ?? '').toString().toLowerCase();
      return naziv.contains(_searchQuery.toLowerCase()) ||
          autor.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final Map<String, String> queryParams = {};
      if (_searchQuery.isNotEmpty) {
        queryParams['query'] = _searchQuery;
      }

      final uri = Uri.http(
        AppConfig.backendUrl,
        '/library/api/search',
        queryParams,
      );

      final response = await AuthService.authenticatedGet(uri);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        setState(() {
          _books = data;
        });
      } else {
        print('Greška pri dohvaćanju knjiga: ${response.statusCode}');
      }
    } catch (e) {
      print('Greška: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const espresso = Color(0xFF3E2A23);
    const mocha = Color(0xFF5C4337);
    const sand = Color(0xFFE9DDCF);
    const ivory = Color(0xFFF7F3EE);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: ivory,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: isMobile ? 80.0 : 100.0,
        backgroundColor: espresso,
        title: const Text('Knjižnica Župe Bl. Alojzija Stepinca Duga Resa'),
        foregroundColor: Colors.white,
        actions: [
          const Center(
            child: Text('Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const CircleAvatar(
                backgroundImage: AssetImage('asset/img1.jpg'),
              ),
            ),
          ),
        ],
      ),
      body: isMobile
          ? SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: buildSidebar(context, compact: true),
                  ),
                  Expanded(
                    child: _buildContentCard(context, showFullWidth: true),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                buildSidebar(context),
                Expanded(
                  child: _buildContentCard(context),
                ),
              ],
            ),
    );
  }

  Widget _buildContentCard(BuildContext context, {bool showFullWidth = false}) {
    const espresso = Color(0xFF3E2A23);
    const sand = Color(0xFFE9DDCF);
    const ivory = Color(0xFFF7F3EE);

    return Container(
      color: ivory,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                      'Pretraživanje sustava',
                      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700, color: espresso),
                    ),
                  ),
                  Divider(
                    height: 5.0,
                    color: sand,
                    thickness: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        fetchBooks();
                      },
                      decoration: InputDecoration(
                        hintText: 'Pretraži po nazivu ili autoru',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF5C4337)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F3EE),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dataTableTheme: DataTableThemeData(
                              headingRowColor: WidgetStateColor.resolveWith((states) => sand),
                              headingTextStyle: const TextStyle(color: espresso, fontWeight: FontWeight.w700),
                              dataTextStyle: const TextStyle(color: espresso),
                              dividerThickness: 1,
                              columnSpacing: 16,
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowHeight: 50,
                              dataRowHeight: 50,
                              columnSpacing: 100.0,
                              columns: const [
                                DataColumn(label: SizedBox(width: 70, child: Align(alignment: Alignment.center, child: Text('ID', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)))),
                                DataColumn(label: SizedBox(width: 150, child: Align(alignment: Alignment.center, child: Text('Naziv knjige', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)))),
                                DataColumn(label: SizedBox(width: 100, child: Align(alignment: Alignment.center, child: Text('Autor knjige', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)))),
                                DataColumn(label: SizedBox(width: 50, child: Align(alignment: Alignment.center, child: Text('Status', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)))),
                                DataColumn(label: SizedBox(width: 100, child: Align(alignment: Alignment.center, child: Text('Zadužio/la', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)))),
                                DataColumn(label: SizedBox(width: 100, child: Align(alignment: Alignment.center, child: Text('Datum', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)))),
                              ],
                              rows: _filteredBooks.map((book) {
                                return DataRow(
                                  onSelectChanged: (_) {
                                    Navigator.pushNamed(context, '/${book['id']}');
                                  },
                                  cells: [
                                    centeredCell(book['id'].toString(), width: 70),
                                    centeredCell(book['title'] ?? '', width: 150),
                                    centeredCell(book['author'] ?? '', width: 100),
                                    DataCell(
                                      SizedBox(
                                        width: 50,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            book['availability'] == true ? Icons.check : Icons.close,
                                            color: book['availability'] == true ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            book['availability'] == true ? '-' : (book['borrowedBy'] ?? ''),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            book['availability'] == true ? '-' : (book['date'] ?? ''),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSidebar(BuildContext context, {bool compact = false}) {
    const espresso = Color(0xFF3E2A23);
    const sand = Color(0xFFE9DDCF);

    if (compact) {
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF9F5F1),
          border: Border(bottom: BorderSide(color: Color(0xFFE7D8C5))),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buildSidebarItem(
                label: 'Pretraživanje knjige',
                icon: Icons.search,
                hovering: _isHovering,
                onEnter: () => setState(() => _isHovering = true),
                onExit: () => setState(() => _isHovering = false),
                onTap: () => Navigator.pushNamed(context, '/pretrazivanje'),
              ),
              buildSidebarItem(
                label: 'Dodavanje nove knjige',
                icon: Icons.add,
                hovering: _isHovering1,
                onEnter: () => setState(() => _isHovering1 = true),
                onExit: () => setState(() => _isHovering1 = false),
                onTap: () => Navigator.pushNamed(context, '/upisknjige'),
              ),
              buildSidebarItem(
                label: 'Povratak na početnu',
                icon: Icons.home,
                hovering: _isHovering3,
                onEnter: () => setState(() => _isHovering3 = true),
                onExit: () => setState(() => _isHovering3 = false),
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 300.0,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F5F1),
        border: Border(right: BorderSide(color: Color(0xFFE7D8C5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSidebarItem(
            label: 'Pretraživanje knjige',
            icon: Icons.search,
            hovering: _isHovering,
            onEnter: () => setState(() => _isHovering = true),
            onExit: () => setState(() => _isHovering = false),
            onTap: () => Navigator.pushNamed(context, '/pretrazivanje'),
          ),
          buildSidebarItem(
            label: 'Dodavanje nove knjige',
            icon: Icons.add,
            hovering: _isHovering1,
            onEnter: () => setState(() => _isHovering1 = true),
            onExit: () => setState(() => _isHovering1 = false),
            onTap: () => Navigator.pushNamed(context, '/upisknjige'),
          ),
          buildSidebarItem(
            label: 'Povratak na početnu',
            icon: Icons.home,
            hovering: _isHovering3,
            onEnter: () => setState(() => _isHovering3 = true),
            onExit: () => setState(() => _isHovering3 = false),
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sand,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biblioteka', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: espresso, letterSpacing: 1.1)),
                  SizedBox(height: 8),
                  Text('Moderni sustav upravljanja knjižnicom', style: TextStyle(fontSize: 13, color: espresso)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSidebarItem({
    required String label,
    required IconData icon,
    required bool hovering,
    required VoidCallback onEnter,
    required VoidCallback onExit,
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
            color: hovering ? const Color(0xFFE9DDCF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF3E2A23)),
                const SizedBox(width: 15.0),
                Text(label, style: const TextStyle(fontSize: 18.0, color: Color(0xFF3E2A23))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
