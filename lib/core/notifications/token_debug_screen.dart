import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'notification_service.dart';

class TokenDebugScreen extends StatefulWidget {
  const TokenDebugScreen({super.key});
  @override
  State<TokenDebugScreen> createState() => _TokenDebugScreenState();
}

class _TokenDebugScreenState extends State<TokenDebugScreen> {
  String? _token;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final token = await NotificationService.getToken();
      if (mounted) {
        setState(() {
          _token = token;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting token: $e');
      if (mounted) {
        setState(() {
          _token = 'Error: $e';
          _loading = false;
        });
      }
    }
  }

  void _copyToken() {
    if (_token != null) {
      Clipboard.setData(ClipboardData(text: _token!));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Token copied!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Token')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your FCM Token:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      _token ?? 'No token available',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _copyToken,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Token'),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Use this token to send test notifications from Firebase Console',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
