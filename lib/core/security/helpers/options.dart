part of '../security_service.dart';

abstract class _BaseLockOptions {
  final BuildContext context;
  final SecurityObject? object;
  final Future<bool> Function(bool authenticated) next;
  final LockType lockType;
  final LockFlowType flowType;

  _BaseLockOptions({
    required this.context,
    required this.object,
    required this.lockType,
    required this.next,
    required this.flowType,
  });

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
    required super.lockType,
    required super.next,
    required super.flowType,
  });
}

class PinCodeOptions extends _BaseLockOptions {
  PinCodeOptions({
    required super.context,
    required super.object,
    required super.lockType,
    required super.next,
    required super.flowType,
  });
}
