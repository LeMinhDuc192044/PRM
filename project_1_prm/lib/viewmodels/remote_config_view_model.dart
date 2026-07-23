import 'package:flutter/foundation.dart';
import 'package:project_1_prm/services/remote_config_service.dart';

class RemoteConfigViewModel extends ChangeNotifier {
  RemoteConfigViewModel({RemoteConfigService? remoteConfigService})
    : _remoteConfigService = remoteConfigService ?? RemoteConfigService() {
    refresh();
  }

  final RemoteConfigService _remoteConfigService;

  RemoteConfigValues _values = RemoteConfigService.defaults;
  bool _isLoading = false;
  String? _errorMessage;

  RemoteConfigValues get values => _values;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _values = await _remoteConfigService.fetchValues();
    } catch (error) {
      _errorMessage = error.toString();
      _values = RemoteConfigService.defaults;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
