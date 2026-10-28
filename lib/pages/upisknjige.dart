import 'dart:convert';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';

class EnterBook extends StatefulWidget {
  const EnterBook({super.key});

  @override
  State<EnterBook> createState() => _EnterBookState();
}

class _EnterBookState extends State<EnterBook> {
  bool _isHovering = false;
  bool _isHovering1 = false;
  bool _isHovering2 = false;
  bool _isHovering3 = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();

  bool _isLoading = false;
  String? _message;

  Future<void> addBook() async {
    final String title = _titleController.text.trim();
    final String author = _authorController.text.trim();
    final int? id = int.tryParse(_idController.text.trim());

    if (title.isEmpty || author.isEmpty || id == null) {
      setState(() {
        _message = "Molimo unesite i naslov i autora knjige.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final uri = Uri.http(AppConfig.backendUrl, '/library/api/addBook');
      final headers = {
        'Content-Type': 'application/json; charset=utf-8',
      };
      final body = utf8.encode(jsonEncode({
        'id': id,
        'title': title,
        'author': author,
        'signature': _signatureController.text.trim(),
      }));

      final response = await AuthService.authenticatedPost(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _message = "Knjiga je uspješno dodana!";
          _titleController.clear();
          _authorController.clear();
          _idController.clear();
          _signatureController.clear();
        });
      } else {
        setState(() {
          _message = "Greška pri dodavanju knjige: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Greška pri dodavanju knjige: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _idController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const espresso = Color(0xFF3E2A23);
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
          Center(
            child: Text(
              'Admin',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('asset/img1.jpg'),
              ),
            ),
          ),
        ],
      ),
      body: isMobile
          ? Column(
              children: [
                _buildSidebar(compact: true),
                Expanded(
                  child: _buildFormBody(context),
                ),
              ],
            )
          : Row(
              children: [
                _buildSidebar(),
                Expanded(
                  child: _buildFormBody(context),
                ),
              ],
            ),
    );
  }

  Widget _buildFormBody(BuildContext context) {
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
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                      'Dodavanje knjige u sustav',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                        color: espresso,
                      ),
                    ),
                  ),
                  Divider(
                    height: 5.0,
                    color: sand,
                    thickness: 1.0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputRow(context, icon: Icons.book, label: 'ID*', controller: _idController, hintText: 'Unesite ID knjige'),
                          _buildInputRow(context, icon: Icons.book, label: 'Naslov*', controller: _titleController, hintText: 'Unesite naslov knjige'),
                          _buildInputRow(context, icon: Icons.person, label: 'Autor*', controller: _authorController, hintText: 'Unesite ime i prezime autora knjige'),
                          _buildInputRow(context, icon: Icons.bookmark, label: 'Signatura*', controller: _signatureController, hintText: 'Unesite signaturu knjige'),
                          if (_message != null) ...[
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: _message!.contains('uspješno') ? const Color(0xFFEAF7EE) : const Color(0xFFFFF0F0),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _message!.contains('uspješno') ? const Color(0xFFCDE8D6) : const Color(0xFFE7B4B4),
                                  ),
                                ),
                                child: Text(
                                  _message!,
                                  style: TextStyle(
                                    color: _message!.contains('uspješno') ? Colors.green.shade700 : Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(0.0, 0.0, 60.0, 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: _isLoading ? null : addBook,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: _isLoading ? Colors.grey : espresso,
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Icon(Icons.add, color: Colors.white, size: 30),
                          ),
                        ),
                      ],
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

  Widget _buildSidebar({bool compact = false}) {
    return Container(
      width: compact ? double.infinity : 300,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F5F1),
        border: Border(right: BorderSide(color: Color(0xFFE7D8C5))),
      ),
      child: SingleChildScrollView(
        scrollDirection: compact ? Axis.horizontal : Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: compact ? MediaQuery.of(context).size.width : 0),
          child: Column(
            crossAxisAlignment: compact ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
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
                hovering: _isHovering3,
                onEnter: () => setState(() => _isHovering3 = true),
                onExit: () => setState(() => _isHovering3 = false),
                icon: Icons.home,
                label: 'Povratak na početnu',
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: compact ? MediaQuery.of(context).size.width - 40 : double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9DDCF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dodavanje', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF3E2A23))),
                      SizedBox(height: 8),
                      Text('Novi unosi se evidentiraju u modernom obrascu.', style: TextStyle(fontSize: 13, color: Color(0xFF3E2A23))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF5C4337)),
                const SizedBox(width: 10),
                Text(label, style: const TextStyle(fontSize: 18, color: Color(0xFF3E2A23))),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: hintText,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.book, color: const Color(0xFF5C4337)),
                SizedBox(width: 10),
                Text(label, style: const TextStyle(fontSize: 20.0, color: Color(0xFF3E2A23))),
              ],
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: hintText,
              ),
            ),
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
            color: hovering ? const Color(0xFFE9DDCF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF3E2A23)),
              const SizedBox(width: 15),
              Text(label, style: const TextStyle(fontSize: 18, color: Color(0xFF3E2A23))),
            ],
          ),
        ),
      ),
    );
  }
}
