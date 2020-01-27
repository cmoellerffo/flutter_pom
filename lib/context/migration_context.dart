import 'package:flutter_pom/context/model_context.dart';
import 'package:flutter_pom/model/database.dart';
import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/table.dart';

class MigrationContext {
  Database db;
  Table table;

  MigrationContext(this.db, this.table);

  /// Adds a new field to the table
  Future<void> addField(Field f) async {
    var columnDefinition = ModelContext.buildCreateFieldStatement(f);
    var statement =
        "ALTER TABLE ${table.tableName} ADD COLUMN $columnDefinition";
    return await db.dbHandle.execute(statement);
  }
}
