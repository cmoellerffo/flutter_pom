import 'package:example/pom/sample_table.dart';
import 'package:flutter_pom/flutter_pom.dart';

class SampleDb extends Database {
  SampleDb() : super("sample.db");

  @override
  Map<Type, Table> initializeDatabase() {

    return <Type, Table> {
      SampleTable: SampleTable()
    };
  }
}