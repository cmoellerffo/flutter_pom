import 'package:flutter_pom/flutter_pom.dart';

class $MigrationInfo extends Table {
  $MigrationInfo() : super("_migration_info");

  IdField id = IdField("id");

  StringField name = StringField("table_name")
      .notNull();

  IntegerField tableRevision = IntegerField("revision")
      .notNull();

  @override
  Table getInstance() {
    return $MigrationInfo();
  }

  @override
  List<Field> initializeFields() {
    return [
      id,
      name,
      tableRevision
    ];
  }

  @override
  int get revision => 1;

}