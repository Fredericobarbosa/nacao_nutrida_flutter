import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/left_sidebar.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              rightText: '',
              rightButtonText: 'Login',
              onRightButtonPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
            Padding(padding: const EdgeInsets.all(24), child: LeftSidebar()),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
