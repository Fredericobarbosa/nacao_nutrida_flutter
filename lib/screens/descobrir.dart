import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/center_content.dart';

class DescobrirPage extends StatelessWidget {
  const DescobrirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70, // mesma altura do header
                  child: Container(
                    color: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF027ba1),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Header(
                    leftText: '',
                    rightText: 'Não tem conta?',
                    rightButtonText: 'Cadastre-se',
                    onRightButtonPressed: () {
                      Navigator.of(context).pushNamed('/cadastro-usuario');
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.all(24), child: CenterContent()),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
