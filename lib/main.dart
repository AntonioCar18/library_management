import 'package:flutter/material.dart';
import 'package:softwareknjiznica/pages/upisknjige.dart';
import 'pages/pretrazivanje.dart';
import 'pages/izdavanje_knjige.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      routes: {
        '/pretrazivanje': (context) => const SearchBook(),
        '/upisknjige': (context) => const EnterBook(),
        '/izdavanje_knjige': (context) =>  IzdavanjeVracanjeKnjige()
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
                              Navigator.pushNamed(context, '/izdavanje_knjige');
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
