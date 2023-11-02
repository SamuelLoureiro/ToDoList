import 'package:flutter/material.dart';

class LoadgingPage extends StatelessWidget {
  const LoadgingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.black,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              'Carregando...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
