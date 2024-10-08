part of '../security_service.dart';

abstract class _BaseLockOptions {
  _BaseLockOptions({
    required this.context,
    required this.object,
    required this.nextLockType,
    required this.next,
    required this.flowType,
  });

  final BuildContext context;
  final SecurityObject? object;
  final Future<bool> Function(bool authenticated) next;
  final LockType nextLockType;
  final LockFlowType flowType;

  bool get canCancel {
    switch (flowType) {
      case LockFlowType.unlock:
        return false;
      case LockFlowType.remove:
      case LockFlowType.middleware:
      case LockFlowType.set:
        return true;
    }
  }
}

class BiometricsOptions extends _BaseLockOptions {
  BiometricsOptions({
    required super.context,
    required super.object,
    required super.nextLockType,
    required super.next,
    required super.flowType,
  });
}

class PinCodeOptions extends _BaseLockOptions {
  PinCodeOptions({
    required super.context,
    required super.object,
    required super.nextLockType,
    required super.next,
    required super.flowType,
  });
}
