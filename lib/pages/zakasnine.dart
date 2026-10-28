import 'dart:convert';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';

class LateFeesPage extends StatefulWidget {
  const LateFeesPage({super.key});

  @override
  State<LateFeesPage> createState() => _LateFeesPageState();
}

class _LateFeesPageState extends State<LateFeesPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _lateFees = [];

  @override
  void initState() {
    super.initState();
    fetchLateFees();
  }

  Future<void> fetchLateFees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uri = Uri.http(AppConfig.backendUrl, '/library/api/lateFees');
      final response = await AuthService.authenticatedGet(uri);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        setState(() {
          _lateFees = data is List ? data : [];
        });
      } else {
        setState(() {
          _errorMessage = 'Greška pri dohvaćanju zakasnina: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Greška pri dohvaćanju zakasnina: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCell(String text, {double width = 120}) {
    return SizedBox(
      width: width,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const espresso = Color(0xFF3E2A23);
    const mocha = Color(0xFF5C4337);
    const sand = Color(0xFFE9DDCF);
    const ivory = Color(0xFFF7F3EE);

    return Scaffold(
      backgroundColor: ivory,
      appBar: AppBar(
        backgroundColor: espresso,
        title: const Text('Zakasnine'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Popis zakasnina',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w800,
                  color: espresso,
                ),
              ),
              const SizedBox(height: 12.0),
              if (_isLoading)
                const Center(child: CircularProgressIndicator(color: mocha))
              else if (_errorMessage != null)
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else if (_lateFees.isEmpty)
                const Center(
                  child: Text('Nema zakasnina za prikaz.', style: TextStyle(color: espresso)),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                        child: DataTable(
                          headingRowHeight: 56,
                          dataRowHeight: 56,
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Naziv knjige')),
                            DataColumn(label: Text('Autor')),
                            DataColumn(label: Text('Dostupnost')),
                            DataColumn(label: Text('Zadužio/la')),
                            DataColumn(label: Text('Datum')),
                            DataColumn(label: Text('Datum povratka')),
                            DataColumn(label: Text('Potpis')),
                          ],
                          rows: _lateFees.map((item) {
                            final availability = item['availability'] == true;
                            return DataRow(
                              cells: [
                                DataCell(_buildCell(item['id']?.toString() ?? '-', width: 60)),
                                DataCell(_buildCell(item['title'] ?? '-', width: 180)),
                                DataCell(_buildCell(item['author'] ?? '-', width: 140)),
                                DataCell(_buildCell(
                                  availability ? 'Dostupno' : 'Zauzeto',
                                  width: 120,
                                )),
                                DataCell(_buildCell(item['borrowedBy'] ?? '-', width: 130)),
                                DataCell(_buildCell(item['date'] ?? '-', width: 120)),
                                DataCell(_buildCell(item['dateReturnTo'] ?? '-', width: 140)),
                                DataCell(_buildCell(item['signature']?.toString() ?? '-', width: 140)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
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
