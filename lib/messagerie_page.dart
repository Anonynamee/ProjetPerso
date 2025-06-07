import 'package:flutter/material.dart';

class MessageriePage extends StatelessWidget {
  const MessageriePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 209, 209),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('Messagerie privée'),
      ),
      body: Center(child: Text('messages privés.')),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messagerie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Gérer la navigation si nécessaire
        },
      ),
    );
  }
}
