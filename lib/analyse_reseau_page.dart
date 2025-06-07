import 'package:flutter/material.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class AnalyseReseauPage extends StatefulWidget {
  const AnalyseReseauPage({Key? key}) : super(key: key);

  @override
  State<AnalyseReseauPage> createState() => _AnalyseReseauPageState();
}

class _AnalyseReseauPageState extends State<AnalyseReseauPage> {
  List<String> ipsTrouvees = []; // liste des IP détectées
  bool scanEnCours = false; // pour savoir si le scan est en cours
  String ipLocale = ''; // IP locale de l'appareil
  String ipActuelle = ''; // IP en train d'être scannée
  int total = 254; // nombre total d'IP à scanner
  int scanActuel = 0; // compteur d'IP déjà scannées
  final portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    portController.text = '80'; // port par défaut
  }

  void commencerScan() async {
    // on démarre le scan, on remet tout à zéro
    setState(() {
      scanEnCours = true;
      ipsTrouvees.clear();
      ipActuelle = '';
      scanActuel = 0;
    });

    // on récupère l'IP locale
    final wifi = await WifiInfoPlugin.wifiDetails;
    final ip = wifi?.ipAddress ?? '';

    if (ip.isEmpty) {
      // si on n'a pas pu avoir l'IP, on arrête tout
      setState(() {
        ipLocale = ' IP non trouvée';
        scanEnCours = false;
      });
      return;
    }

    setState(() {
      ipLocale = ip; // on affiche l'IP locale
    });

    // on récupère le début du réseau (ex: 192.168.1)
    final sousReseau = ip.substring(0, ip.lastIndexOf('.'));
    final port = int.tryParse(portController.text) ?? 80; // port à scanner

    // on lance le scan sur le réseau local
    final scan = NetworkAnalyzer.i.discover(sousReseau, port);

    // on écoute les résultats au fur et à mesure
    scan
        .listen((adresse) {
          setState(() {
            ipActuelle = adresse.ip; // IP en cours de scan
            scanActuel++; // on augmente le compteur
            if (adresse.exists) {
              ipsTrouvees.add(adresse.ip); // on ajoute si appareil trouvé
            }
          });
        })
        .onDone(() {
          // quand le scan est fini, on met à jour l'état
          setState(() {
            scanEnCours = false;
            ipActuelle = '';
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        217,
        209,
        209,
      ), // couleur de fond
      appBar: AppBar(
        backgroundColor: Colors.amberAccent, // couleur de la barre du haut
        title: const Text('Scanner réseau'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // marge autour
        child: Column(
          children: [
            TextField(
              controller: portController, // champ pour entrer le port
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port à scanner',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed:
                  scanEnCours
                      ? null
                      : commencerScan, // bouton désactivé pendant le scan
              child: Text(
                scanEnCours ? 'Scan en cours...' : 'Démarrer le scan',
              ),
            ),
            const SizedBox(height: 15),
            Text('Votre IP : $ipLocale'), // affichage de l'IP locale
            const SizedBox(height: 15),
            if (scanEnCours) ...[
              LinearProgressIndicator(
                value: scanActuel / total,
              ), // barre de progression
              const SizedBox(height: 10),
              Text('En cours : $ipActuelle'), // IP en cours de scan
              Text('Progression : $scanActuel / $total'), // avancement
              Text(
                'Appareils trouvés : ${ipsTrouvees.length}',
              ), // nombre d'appareils détectés
            ],
            const SizedBox(height: 15),
            scanEnCours
                ? const CircularProgressIndicator() // roue qui tourne pendant le scan
                : Expanded(
                  child:
                      ipsTrouvees.isEmpty
                          ? const Text(
                            'Aucun appareil détecté',
                          ) // message si rien trouvé
                          : ListView.builder(
                            itemCount: ipsTrouvees.length,
                            itemBuilder:
                                (context, index) => ListTile(
                                  leading: const Icon(
                                    Icons.wifi,
                                  ), // icône devant chaque IP
                                  title: Text(
                                    ipsTrouvees[index],
                                  ), // IP détectée
                                ),
                          ),
                ),
          ],
        ),
      ),
    );
  }
}
