part of security_service;

class SecurityInformations {
  final LocalAuthentication localAuth;
  final SecurityPersistanceProvider storage;

  SecurityInformations({
    required this.localAuth,
    required this.storage,
  });

  bool? _hasFaceID;
  bool? _hasFingerprint;
  bool? _hasIris;
  bool? _hasStrong;
  bool? _hasWeak;

  bool get hasFaceID => _hasFaceID ?? false;
  bool get hasFingerprint => _hasFingerprint ?? false;
  bool get hasIris => _hasIris ?? false;
  bool get hasStrong => _hasStrong ?? false;
  bool get hasWeak => _hasWeak ?? false;

  bool get hasLocalAuth =>
      hasFaceID || hasFingerprint || hasIris || hasStrong || hasWeak;

  Future<void> initialize() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics &&
        await localAuth.isDeviceSupported();
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      _hasFaceID = availableBiometrics.contains(BiometricType.face);
      _hasFingerprint = availableBiometrics.contains(BiometricType.fingerprint);
      _hasIris = availableBiometrics.contains(BiometricType.iris);
      _hasStrong = availableBiometrics.contains(BiometricType.strong);
      _hasWeak = availableBiometrics.contains(BiometricType.weak);
    }
  }

  Future<SecurityObject> getLock() => storage.getLock();
  Future<void> clear() => storage.clear();
}
