part of '../security_service.dart';

class SecurityInformations with ConsoleMixin {
  final LocalAuthentication localAuth;
  final SecurityPersistanceProvider storage;

  SecurityInformations({
    required this.localAuth,
    required this.storage,
  });

  // Flag to indicate if biometrics availability has been checked
  bool _biometricsChecked = false;

  // Use a single map to store all biometric availabilities
  final Map<BiometricType, bool> _biometricAvailability = {};

  bool get hasFaceID => _biometricAvailability[BiometricType.face] ?? false;
  bool get hasFingerprint =>
      _biometricAvailability[BiometricType.fingerprint] ?? false;
  bool get hasIris => _biometricAvailability[BiometricType.iris] ?? false;
  bool get hasStrong => _biometricAvailability[BiometricType.strong] ?? false;
  bool get hasWeak => _biometricAvailability[BiometricType.weak] ?? false;

  bool get hasLocalAuth =>
      _biometricAvailability.values.any((element) => element);

  Future<void> initialize() async {
    if (!_biometricsChecked) {
      try {
        final canCheckBiometrics = await localAuth.canCheckBiometrics &&
            await localAuth.isDeviceSupported();
        if (canCheckBiometrics) {
          final availableBiometrics = await localAuth.getAvailableBiometrics();
          for (final type in availableBiometrics) {
            _biometricAvailability[type] = true;
          }
        }
        _biometricsChecked = true;
      } on PlatformException catch (e) {
        console.error(e.message.toString());
      }
    }
  }

  Future<SecurityObject> getLock() => storage.getLock();
  Future<void> clear() => storage.clear();
}
