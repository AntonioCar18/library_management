import 'package:flutter/material.dart';
import 'package:softwareknjiznica/pages/izdavanje_knjige.dart';
import 'package:softwareknjiznica/pages/pretrazivanje.dart';
import 'package:softwareknjiznica/pages/upisknjige.dart';
import 'package:softwareknjiznica/pages/zakasnine.dart';

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
    const espresso = Color(0xFF3E2A23);
    const mocha = Color(0xFF5C4337);
    const sand = Color(0xFFE9DDCF);
    const ivory = Color(0xFFF7F3EE);

    final menuItems = [
      {
        'title': 'PRETRAŽIVANJE KNJIGA',
        'icon': Icons.search_rounded,
        'image': 'asset/img2.jpg',
        'route': '/pretrazivanje',
      },
      {
        'title': 'UPISIVANJE NOVE KNJIGE',
        'icon': Icons.library_add_rounded,
        'image': 'asset/img3.jpg',
        'route': '/upisknjige',
      },
      {
        'title': 'ZAKASNINE',
        'icon': Icons.schedule_rounded,
        'image': null,
        'route': '/zakasnine',
      },
    ];

    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: isMobile ? 80.0 : 100.0,
        backgroundColor: espresso,
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ivory, Color(0xFFF1E6DB)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 18.0 : 32.0, vertical: isMobile ? 20.0 : 40.0),
          child: Column(
            children: [
              Text(
                'KORISNIČKA PLOČA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 28.0 : 42.0,
                  fontWeight: FontWeight.w800,
                  color: espresso,
                  letterSpacing: isMobile ? 0.8 : 1.2,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: isMobile ? 16 : 36,
                    runSpacing: isMobile ? 18 : 26,
                    alignment: WrapAlignment.center,
                    children: menuItems.map((item) {
                      final String title = item['title'] as String;
                      final String? image = item['image'] as String?;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(26),
                          onTap: () => Navigator.pushNamed(context, item['route'] as String),
                          child: Container(
                            width: isMobile ? 220 : 260,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.brown.withOpacity(0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: isMobile ? 128 : 170,
                                  height: isMobile ? 128 : 170,
                                  decoration: BoxDecoration(
                                    color: sand,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(color: const Color(0xFFD7C5AE), width: 1.5),
                                  ),
                                  child: image != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.asset(
                                            image,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.schedule_rounded,
                                          size: 86,
                                          color: mocha,
                                        ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 22,
                                    fontWeight: FontWeight.w700,
                                    color: espresso,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
