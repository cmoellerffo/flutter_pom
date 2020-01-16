import 'package:flutter_pom/flutter_pom.dart';

class FieldConstraintError extends Error {
  final Field field;
  final String message;

  FieldConstraintError(this.field, this.message) : super();
}