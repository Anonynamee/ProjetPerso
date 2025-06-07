import 'package:flutter/material.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart'; // pour kReleaseMode

// Initialisation du logger avec désactivation en mode production
final Logger logger = Logger(level: kReleaseMode ? Level.nothing : Level.debug);

class AnalyseReseauPage extends StatefulWidget {
  const AnalyseReseauPage({super.key});

  @override
  State<AnalyseReseauPage> createState() => _AnalyseReseauPageState();
}

class _AnalyseReseauPageState extends State<AnalyseReseauPage> {
  List<String> ipTrouvees = [];
  bool enCours = false;
  String localIp = '';
  String ipEnCours = '';
  int totalScan = 0;
  int currentScan = 0;
  final TextEditingController portController = TextEditingController(
    text: '80',
  );

  Future<void> analyserReseau() async {
    setState(() {
      enCours = true;
      ipTrouvees.clear();
      ipEnCours = '';
      totalScan = 254; 
      // totalScan = 20; 
      currentScan = 0;
    });

    logger.i('🔍 Début de l’analyse réseau');

    final wifiDetails = await WifiInfoPlugin.wifiDetails;
    final ip = wifiDetails?.ipAddress ?? '';

    if (ip.isEmpty) {
      setState(() {
        localIp = 'Impossible de récupérer l’adresse IP.';
        enCours = false;
      });
      logger.w(' Impossible de récupérer l’adresse IP locale.');
      return;
    }

    setState(() {
      localIp = ip;
    });
    logger.i(' Adresse IP locale : $ip');

    final subnet = ip.substring(0, ip.lastIndexOf('.'));
    int port = int.tryParse(portController.text) ?? 80;
    logger.i(' Scan du réseau $subnet.0/24 sur le port $port');

    // Scan tout le réseau (de .1 à .254)
    final stream = NetworkAnalyzer.i.discover(subnet, port);
    // Si la lib supporte:
    // final stream = NetworkAnalyzer.i.discover(subnet, port, first: 1, last: 20); // <-- Limite le scan pour tester

    stream
        .listen((NetworkAddress addr) {
          setState(() {
            ipEnCours = addr.ip;
            currentScan++;
            if (addr.exists) {
              ipTrouvees.add(addr.ip);
            }
          });
          if (addr.exists) {
            logger.i(' Appareil détecté : ${addr.ip}');
          }
        })
        .onDone(() {
          setState(() {
            enCours = false;
            ipEnCours = '';
          });
          logger.i(
            ' Analyse réseau terminée. ${ipTrouvees.length} appareil(s) trouvé(s).',
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double progress = totalScan > 0 ? currentScan / totalScan : 0;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 209, 209),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Analyse réseau'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: enCours ? null : analyserReseau,
              child: Text(enCours ? 'Analyse en cours...' : 'Lancer l’analyse'),
            ),
            const SizedBox(height: 20),
            Text('Adresse IP locale : $localIp'),
            const SizedBox(height: 10),
            if (enCours) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 10),
              Text('Scan de : $ipEnCours'),
              Text('Progression : $currentScan / $totalScan'),
              Text('IP trouvées : ${ipTrouvees.length}'),
            ],
            const SizedBox(height: 10),
            enCours
                ? const CircularProgressIndicator()
                : Expanded(
                  child:
                      ipTrouvees.isEmpty
                          ? const Text('Aucun appareil détecté.')
                          : ListView.builder(
                            itemCount: ipTrouvees.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.devices),
                                title: Text(ipTrouvees[index]),
                              );
                            },
                          ),
                ),
          ],
        ),
      ),
    );
  }
}
