part of 'account.controller.dart';

enum SyncingState {
  idle,
  syncing,
  success,
  error,
}

class AccountState extends Equatable {
  final int lastSync;
  final String userId;
  final bool isSyncRequired;
  final bool isSyncing;
  final SyncingState syncingState;
  final String errorMessage;

  const AccountState(
    this.lastSync,
    this.userId,
    this.isSyncRequired,
    this.isSyncing,
    this.syncingState,
    this.errorMessage,
  );

  factory AccountState.initial() => const AccountState(
      1139941800000, "Anonymous", false, false, SyncingState.idle, '');

  @override
  List<Object> get props =>
      [lastSync, userId, isSyncRequired, isSyncing, syncingState, errorMessage];

  AccountState copyWith({
    int? lastSync,
    String? userId,
    bool? isSyncRequired,
    bool? isSyncing,
    SyncingState? syncingState,
    String? errorMessage,
  }) {
    return AccountState(
      lastSync ?? this.lastSync,
      userId ?? this.userId,
      isSyncRequired ?? this.isSyncRequired,
      isSyncing ?? this.isSyncing,
      syncingState ?? this.syncingState,
      errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool get stringify => true;
}
