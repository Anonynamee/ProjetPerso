import 'package:flutter/material.dart';

class LocalisationPage extends StatelessWidget {
  const LocalisationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 209, 209),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('Localisation'),
      ),
      body: Center(child: Text('Localisation')),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Localisation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.network_check),
            label: 'Analyse réseau',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messagerie',
          ),
        ],
      ),
    );
  }
}
