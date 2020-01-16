import 'package:flutter_pom/flutter_pom.dart';

abstract class TableConfigurationError extends Error {
  final Table table;

  TableConfigurationError(this.table);
}