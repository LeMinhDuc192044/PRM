import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:project_1_prm/services/firebase_bootstrap_service.dart';

class RemoteConfigValues {
  const RemoteConfigValues({
    required this.appTitle,
    required this.welcomeMessage,
    required this.enablePdfExport,
  });

  final String appTitle;
  final String welcomeMessage;
  final bool enablePdfExport;
}

class RemoteConfigService {
  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig;

  static const RemoteConfigValues defaults = RemoteConfigValues(
    appTitle: 'Scientific Paper Reader',
    welcomeMessage: 'Analyze, read, and export scientific papers.',
    enablePdfExport: true,
  );

  final FirebaseRemoteConfig? _remoteConfig;

  bool get isAvailable => FirebaseBootstrapService.isInitialized;

  FirebaseRemoteConfig get _instance {
    if (!isAvailable) {
      throw StateError('Firebase Remote Config is not configured yet.');
    }
    return _remoteConfig ?? FirebaseRemoteConfig.instance;
  }

  Future<RemoteConfigValues> fetchValues() async {
    if (!isAvailable) return defaults;

    await _instance.setDefaults(<String, dynamic>{
      'app_title': defaults.appTitle,
      'welcome_message': defaults.welcomeMessage,
      'enable_pdf_export': defaults.enablePdfExport,
    });
    await _instance.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 30),
      ),
    );
    await _instance.fetchAndActivate();

    return RemoteConfigValues(
      appTitle: _instance.getString('app_title'),
      welcomeMessage: _instance.getString('welcome_message'),
      enablePdfExport: _instance.getBool('enable_pdf_export'),
    );
  }
}
