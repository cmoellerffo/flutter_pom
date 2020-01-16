import 'package:flutter_pom/errors/table_configuration_error.dart';
import 'package:flutter_pom/flutter_pom.dart';

class MultiplePrimaryKeyError extends TableConfigurationError {
  MultiplePrimaryKeyError(Table table) : super(table);
}