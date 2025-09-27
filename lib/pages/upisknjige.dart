import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  bool _isLoading = false;
  String? _message;

  Future<void> addBook() async {
    final String title = _titleController.text.trim();
    final String author = _authorController.text.trim();

    if (title.isEmpty || author.isEmpty) {
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
      final uri = Uri.https('6286f066d9d3.ngrok-free.app', '/library/api/addBook');
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'title': title,
        'author': author,
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _message = "Knjiga je uspješno dodana!";
          _titleController.clear();
          _authorController.clear();
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
    super.dispose();
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
          Center(
            child: Text(
              'Admin',
              style: TextStyle(color: Colors.white),
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
      body: Row(
        children: [
          Container(
            width: 300.0,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering = false;
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/pretrazivanje');
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _isHovering
                            ? Colors.grey.shade300
                            : Colors.grey.shade300.withAlpha(0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 15.0),
                            Text(
                              'Pretraživanje knjige',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering1 = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering1 = false;
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/upisknjige');
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _isHovering1
                            ? Colors.grey.shade300
                            : Colors.grey.shade300.withAlpha(0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 15.0),
                            Text(
                              'Dodavanje nove knjige',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering2 = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering2 = false;
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/izdavanje_knjige');
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _isHovering2
                            ? Colors.grey.shade300
                            : Colors.grey.shade300.withAlpha(0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.read_more),
                            SizedBox(width: 15.0),
                            Text(
                              'Upravljanje knjigom',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering3 = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering3 = false;
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _isHovering3
                            ? Colors.grey.shade300
                            : Colors.grey.shade300.withAlpha(0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.home),
                            SizedBox(width: 15.0),
                            Text(
                              'Povratak na početnu',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: constraints.maxHeight,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Text(
                              'Dodavanje knjige u sustav',
                              style: TextStyle(
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.grey.shade100,
                            thickness: 1.0,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      Icon(Icons.book),
                                      SizedBox(width: 10),
                                      Text(
                                        'Naslov*',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Unesite naslov knjige',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      Icon(Icons.person),
                                      SizedBox(width: 10),
                                      Text(
                                        'Autor*',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: _authorController,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText:
                                          'Unesite ime i prezime autora knjige',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (_message != null) ...[
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                _message!,
                                style: TextStyle(
                                  color: _message!.contains('uspješno')
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],

                          Spacer(),

                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0.0, 0.0, 60.0, 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: _isLoading ? null : addBook,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: _isLoading
                                        ? Colors.grey
                                        : Colors.blue[900],
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 30,
                                          ),
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
            ),
          ),
        ],
      ),
    );
  }
}
