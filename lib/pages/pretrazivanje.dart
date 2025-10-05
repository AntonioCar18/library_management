import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
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

      final uri = Uri.https(
        '0b5cecd8b187.ngrok-free.app',
        '/library/api/search',
        queryParams,
      );

      final headers = {
        'ngrok-skip-browser-warning': 'true',
      };

      final response = await http.get(uri, headers: headers);

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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        backgroundColor: Colors.blue[900],
        title: const Text('Knjižnica Župe Bl. Alojzija Stepinca Duga Resa'),
        foregroundColor: Colors.white,
        actions: [
          const Center(
            child: Text('Admin', style: TextStyle(color: Colors.white)),
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
      body: Row(
        children: [
          buildSidebar(context),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: constraints.maxHeight,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Text(
                              'Pretraživanje sustava',
                              style: TextStyle(fontSize: 25.0),
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.grey.shade100,
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
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: DataTable(
                                        headingRowHeight: 50,
                                        dataRowHeight: 50,
                                        columnSpacing: 100.0,
                                        columns: const [
                                          DataColumn(
                                            label: SizedBox(
                                              width: 30,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'ID',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: 150,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Naziv knjige',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: 100,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Autor knjige',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: 50,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Status',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: 100,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Zadužio/la',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width: 100,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Datum',
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: _filteredBooks.map((book) {
                                          return DataRow(
                                            onSelectChanged: (_){
                                              Navigator.pushNamed(
                                                context, 
                                                '/izdavanje_knjige',
                                                arguments: {
                                                'id': book['id'],
                                                'title': book['title'],
                                                'author': book['author'],
                                                'borrowedBy': book['borrowedBy'],
                                                'date': book['date'],
                                                },
                                              );
                                            },
                                            cells: [
                                              centeredCell(book['id'].toString(), width: 30),
                                              centeredCell(book['title'] ?? '', width: 150),
                                              centeredCell(book['author'] ?? '', width: 100),
                                              DataCell(
                                                SizedBox(
                                                  width: 50,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      book['availability'] == true
                                                          ? Icons.check
                                                          : Icons.close,
                                                      color: book['availability'] == true
                                                          ? Colors.green
                                                          : Colors.red,
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
                                                      book['availability'] == true
                                                          ? '-'
                                                          : (book['borrowedBy'] ?? ''),
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
                                                      book['availability'] == true
                                                          ? '-'
                                                          : (book['date'] ?? ''),
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar builder
  Widget buildSidebar(BuildContext context) {
    return Container(
      width: 300.0,
      color: Colors.white,
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
            label: 'Upravljanje knjigom',
            icon: Icons.read_more,
            hovering: _isHovering2,
            onEnter: () => setState(() => _isHovering2 = true),
            onExit: () => setState(() => _isHovering2 = false),
            onTap: () => Navigator.pushNamed(context, '/izdavanje_knjige'),
          ),
          buildSidebarItem(
            label: 'Povratak na početnu',
            icon: Icons.home,
            hovering: _isHovering3,
            onEnter: () => setState(() => _isHovering3 = true),
            onExit: () => setState(() => _isHovering3 = false),
            onTap: () => Navigator.pushNamed(context, '/'),
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
            color: hovering ? Colors.grey.shade300 : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 15.0),
                Text(label, style: const TextStyle(fontSize: 18.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
