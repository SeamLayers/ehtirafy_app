import 'package:ehtirafy_app/features/client/profile/presentation/pages/test_payment_screen.dart';
import 'package:flutter/material.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Screen Placeholder'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TestPaymentScreen(),
                  ),
                );
              },
              child: const Text('Run Payment Test (Fake Data)'),
            ),
          ],
        ),
      ),
    );
  }
}
