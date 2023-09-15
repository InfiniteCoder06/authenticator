// 🌎 Project imports:
import 'package:authenticator/core/types/lock.type.dart';

class SecurityObject {
  final String secret;
  final LockType type;

  SecurityObject(this.type, this.secret);
}
