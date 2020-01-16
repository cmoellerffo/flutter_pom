import 'package:flutter_pom/errors/table_configuration_error.dart';
import 'package:flutter_pom/model/table.dart';

class MissingPrimaryKeyError extends TableConfigurationError {
  MissingPrimaryKeyError(Table table) : super(table);
}