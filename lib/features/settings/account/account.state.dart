part of 'account.controller.dart';

class AccountState extends Equatable {
  final int cloudUpdated;
  final int localUpdated;

  const AccountState(
    this.cloudUpdated,
    this.localUpdated,
  );

  factory AccountState.initial() =>
      const AccountState(1139941800000, 1139941800000);

  factory AccountState.success(int cloudUpdated, int localUpdated) =>
      AccountState(cloudUpdated, localUpdated);

  @override
  List<Object?> get props => [cloudUpdated, localUpdated];

  AccountState copyWith({
    int? cloudUpdated,
    int? localUpdated,
  }) {
    return AccountState(
      cloudUpdated ?? this.cloudUpdated,
      localUpdated ?? this.localUpdated,
    );
  }

  @override
  bool get stringify => true;
}
