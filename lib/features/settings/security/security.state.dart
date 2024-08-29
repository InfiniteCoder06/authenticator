part of 'security.controller.dart';

class SecurityState extends Equatable {
  const SecurityState({
    required this.isEnabled,
    required this.hasBiometrics,
    required this.biometrics,
  });

  factory SecurityState.initial() => const SecurityState(
      isEnabled: true, hasBiometrics: true, biometrics: false);

  final bool isEnabled;
  final bool hasBiometrics;
  final bool biometrics;

  @override
  List<Object?> get props => [isEnabled, hasBiometrics, biometrics];

  SecurityState copyWith({
    bool? isEnabled,
    bool? hasBiometrics,
    bool? biometrics,
  }) {
    return SecurityState(
      isEnabled: isEnabled ?? this.isEnabled,
      hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      biometrics: biometrics ?? this.biometrics,
    );
  }

  @override
  bool get stringify => true;
}
