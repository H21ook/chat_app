import 'package:flutter/foundation.dart';

dPrint(Object object) {
  if (kDebugMode) {
    print("[DEBUG]: $object");
  }
}
