import 'package:flutter/material.dart';
import 'package:softwareknjiznica/pages/upisknjige.dart';
import 'pages/pretrazivanje.dart';
import 'pages/izdavanje_knjige.dart';
import 'pages/test_page.dart';
import 'dart:io';

void main() async  {


  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    Process? backend;

  @override
  void initState() {
    super.initState();
    //_startBackend();
  }

  Future<void> _startBackend() async {
    backend = await Process.start(
      'java',
      ['-jar', r"..\\backend\\app.jar"],
      mode: ProcessStartMode.detached,
      runInShell: false,
    );
  }

  //@override
  //void dispose() {
    // Kada se Flutter prozor zatvori, backend se ubija
    //backend?.kill();
    //super.dispose();
  //}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      routes: {
        '/pretrazivanje': (context) => const SearchBook(),
        '/upisknjige': (context) => const EnterBook(),
        '/test': (context) => const TestPage(),
      },
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        final uri = Uri.parse(name);
        if (uri.pathSegments.length == 1 && uri.pathSegments.first.isNotEmpty) {
          final id = uri.pathSegments.first;
          return MaterialPageRoute(
            builder: (context) => IzdavanjeVracanjeKnjige(bookId: id),
            settings: settings,
          );
        }
        return null;
      },
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100.0,
          backgroundColor: Colors.blue[900],
          title: const Text('Knjižnica Župe Bl. Alojzija Stepinca Duga Resa'),
          foregroundColor: Colors.white,
          actions: const [
            Center(
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('asset/img1.jpg'),
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: const Text(
                      'KORISNIČKA PLOČA',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Wrap(
                    spacing: 60, // razmak između stupaca
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/pretrazivanje');
                            },
                            child: const CircleAvatar(
                              radius: 120.0,
                              backgroundImage: AssetImage('asset/img2.jpg'),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'PRETRAŽIVANJE KNJIGA',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 100.0),
                      Column(
                        children: [
                          TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/upisknjige');
                            },
                            child: const CircleAvatar(
                              radius: 120.0,
                              backgroundImage: AssetImage('asset/img3.jpg'),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'UPISIVANJE NOVE KNJIGE',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 100.0),
                      Column(
                        children: <Widget>[
                          TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/pretrazivanje');
                            },
                            child: const CircleAvatar(
                              radius: 120.0,
                              backgroundImage: AssetImage('asset/img4.jpg'),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'UPRAVLJANJE KNJIGAMA',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
