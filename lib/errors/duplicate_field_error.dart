import 'package:flutter_pom/errors/table_configuration_error.dart';
import 'package:flutter_pom/model/table.dart';

class DuplicateFieldError extends TableConfigurationError {
  final String message;

  DuplicateFieldError(Table table, this.message) : super(table);
}