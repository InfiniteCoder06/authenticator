// 🌎 Project imports:
import 'package:authenticator/core/types/lock.type.dart';

class SecurityObject {
  SecurityObject(this.type, this.secret);

  final String secret;
  final LockType type;
}
