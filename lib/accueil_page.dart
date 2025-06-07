import 'package:flutter/material.dart';
import 'localisation_page.dart';
import 'analyse_reseau_page.dart';
import 'messagerie_page.dart';
import 'device_info_page.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 209, 209),
      appBar: AppBar(
        title: Text('Projet'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalisationPage()),
                );
              },
              child: Text('Localisation'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalyseReseauPage()),
                );
              },
              child: Text('Analyse Réseau'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessageriePage()),
                );
              },
              child: Text('Messagerie'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => DeviceInfoPage()),
             );
},
     child: Text('Voir infos appareil'),
),

          ],
        ),
      ),
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
