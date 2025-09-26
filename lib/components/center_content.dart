import 'package:flutter/material.dart';

class CenterContent extends StatelessWidget {
  const CenterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero Banner
        Card(
          color: const Color(0xFF769fcd),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inspire o estado e a cidade',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encontre organizações que precisam de sua ajuda',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/descobrir');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFffc436),
                    foregroundColor: const Color(0xFF191929),
                  ),
                  child: const Text('Começar agora'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Recent Requests
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Campanhas Existentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191929),
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width < 400
                              ? 60
                              : 100,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Almoço na creche Arco-Íris',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF191929),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Alimentos • Arroz • Feijão • Óleo • Açúcar',
                              style: TextStyle(
                                color: Color(0xFF8d8d8d),
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed('/cadastrar-pedido');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF027ba1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Ver detalhes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPaginationButton('1'),
                const SizedBox(width: 8),
                _buildPaginationButton('2'),
                const SizedBox(width: 8),
                _buildPaginationButton('3'),
                const SizedBox(width: 8),
                const Text('...', style: TextStyle(color: Color(0xFF8d8d8d))),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/descobrir');
                  },
                  child: const Text('Seguinte →'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
      ),
      child: Text(text),
    );
  }
}
