import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Pour defaultTargetPlatform
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  String ip = 'Chargement...';
  String os = 'Chargement...';
  String model = 'Chargement...';
  String appVersion = 'Chargement...';

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      final networkInfo = NetworkInfo();

      // Adresse IP (ne fonctionne pas sur le web)
      String ipAddress = 'Non disponible sur le web';
      if (!kIsWeb) {
        ipAddress = await networkInfo.getWifiIP() ?? 'Inconnue';
      }

      // OS et modèle
      String osName = '';
      String modelName = '';
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        osName = 'Web (${webInfo.browserName.name})';
        modelName = 'User Agent: ${webInfo.userAgent}';
      } else {
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
            osName = 'Platforme non supportée';
        }
      }

      setState(() {
        ip = ipAddress;
        os = osName;
        model = modelName;
        appVersion = packageInfo.version;
      });
    } catch (e) {
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

  Widget _buildInfoTile(String label, String value) {
    return ListTile(title: Text(label), subtitle: Text(value));
  }
}
