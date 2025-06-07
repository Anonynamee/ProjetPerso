import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Pour savoir sur quelle plateforme on est
import 'package:device_info_plus/device_info_plus.dart'; // Pour récupérer les infos du device
import 'package:package_info_plus/package_info_plus.dart'; // Pour la version de l'app
import 'package:network_info_plus/network_info_plus.dart'; // Pour l'IP

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({Key? key}) : super(key: key);

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  String ip = 'Chargement...'; // adresse IP
  String os = 'Chargement...'; // système d'exploitation
  String model = 'Chargement...'; // modèle de l'appareil
  String appVersion = 'Chargement...'; // version de l'app

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo(); // on lance la récupération des infos au démarrage
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      final networkInfo = NetworkInfo();

      // On récupère l'adresse IP (pas dispo sur le web)
      String ipAddress = 'Non disponible sur le web';
      if (!kIsWeb) {
        ipAddress = await networkInfo.getWifiIP() ?? 'Inconnue';
      }

      // Variables pour OS et modèle
      String osName = '';
      String modelName = '';

      if (kIsWeb) {
        // Si on est sur web, on récupère les infos du navigateur
        final webInfo = await deviceInfo.webBrowserInfo;
        osName = 'Web (${webInfo.browserName.name})';
        modelName = 'User Agent: ${webInfo.userAgent}';
      } else {
        // Sinon on regarde la plateforme mobile
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            final androidInfo = await deviceInfo.androidInfo;
            osName = 'Android ${androidInfo.version.release}';
            modelName = '${androidInfo.manufacturer} ${androidInfo.model}';
            break;
          case TargetPlatform.iOS:
            final iosInfo = await deviceInfo.iosInfo;
            osName = 'iOS ${iosInfo.systemVersion}';
            modelName = iosInfo.utsname.machine;
            break;
          default:
            osName = 'Plateforme non supportée';
            modelName = '';
        }
      }

      // On met à jour l'affichage avec les infos récupérées
      setState(() {
        ip = ipAddress;
        os = osName;
        model = modelName;
        appVersion = packageInfo.version;
      });
    } catch (e) {
      // En cas d'erreur, on affiche un message simple
      setState(() {
        ip = 'Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infos de l’appareil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoTile('Adresse IP', ip),
          _buildInfoTile('Système', os),
          _buildInfoTile('Modèle', model),
          _buildInfoTile('Version app', appVersion),
        ],
      ),
    );
  }

  // Petite fonction pour afficher une ligne d'info simple
  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
