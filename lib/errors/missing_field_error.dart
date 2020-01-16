import 'package:flutter_pom/errors/table_configuration_error.dart';
import 'package:flutter_pom/flutter_pom.dart';

class MissingFieldError extends TableConfigurationError {
  final String message;

  MissingFieldError(Table table, this.message) : super(table);
}