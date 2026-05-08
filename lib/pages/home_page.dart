import 'package:flutter/material.dart';
import 'package:softwareknjiznica/pages/izdavanje_knjige.dart';
import 'package:softwareknjiznica/pages/pretrazivanje.dart';
import 'package:softwareknjiznica/pages/upisknjige.dart';

import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService.clearToken();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        backgroundColor: Colors.blue[900],
        title: const Text('Knjižnica Župe Bl. Alojzija Stepinca Duga Resa'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Odjava',
          ),
          const Center(
            child: Text(
              'Admin',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10.0),
          const Padding(
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
                  spacing: 60,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
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
                          onPressed: () {
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
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
