import 'package:example/pom/sample_table.dart';
import 'package:example/pom/sample_table_2.dart';
import 'package:flutter_pom/flutter_pom.dart';

class SampleDb extends Database {
  SampleDb() : super("sample.db", enableMigration: true);

  @override
  Map<Type, Table> initializeDatabase() {

    return <Type, Table> {
      SampleTable: SampleTable(),
      SampleTable2: SampleTable2()
    };
  }
}