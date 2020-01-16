import 'package:flutter_pom/flutter_pom.dart';

import 'flutter_pom_test_table.dart';

class FlutterPomTestDb extends Database {
  FlutterPomTestDb(String name) : super(name);

  @override
  Map<Type, Table> initializeDatabase() {
    return <Type, Table> {
      FlutterPomTestTable: FlutterPomTestTable()
    };
  }

}