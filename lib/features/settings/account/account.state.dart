part of 'account.controller.dart';

class AccountState extends Equatable {
  final int lastSync;
  final String userId;
  final bool isSyncing;

  const AccountState(
    this.lastSync,
    this.userId,
    this.isSyncing,
  );

  factory AccountState.initial() =>
      const AccountState(1139941800000, "Anonymous", false);

  @override
  List<Object> get props => [lastSync, userId, isSyncing];

  AccountState copyWith({
    int? lastSync,
    String? userId,
    bool? isSyncing,
  }) {
    return AccountState(
      lastSync ?? this.lastSync,
      userId ?? this.userId,
      isSyncing ?? this.isSyncing,
    );
  }

  @override
  bool get stringify => true;
}
