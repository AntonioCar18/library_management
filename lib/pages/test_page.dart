import 'dart:convert';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../services/auth_service.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool _isLoading = true;
  String? _error;
  dynamic _data;

  @override
  void initState() {
    super.initState();
    _fetchTestData();
  }

  Future<void> _fetchTestData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final uri = Uri.http(AppConfig.backendUrl, '/library/api/test');
      final response = await AuthService.authenticatedGet(uri);

      if (response.statusCode == 200) {
        setState(() {
          _data = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Greška: ${response.statusCode} - ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Greška pri pozivu API-ja: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _error != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchTestData,
                          child: const Text('Pokušaj ponovno'),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 48),
                        const SizedBox(height: 16),
                        const Text(
                          'Odgovor sa backenda:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _data is String
                                  ? _data
                                  : const JsonEncoder.withIndent('  ').convert(_data),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchTestData,
                          child: const Text('Osvježi'),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
