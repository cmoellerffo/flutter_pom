import 'package:flutter_pom/context/base_model_context.dart';
import 'package:flutter_pom/context/migration_context.dart';
import 'package:flutter_pom/context/model_context.dart';
import 'package:flutter_pom/context/pom_logger.dart';
import 'package:flutter_pom/model/migration_info.dart';
import 'package:flutter_pom/builder/selectors/sql_condition.dart';
import 'package:flutter_pom/model/table.dart';
import 'package:sqflite/sqflite.dart' as b;

abstract class Database {
  Map<Type, Table> _tables;
  Map<Type, ModelContext> _modelTables = <Type, ModelContext>{};

  ModelContext<$MigrationInfo> _migrationContext;
  final $MigrationInfo _migrationInfo = $MigrationInfo();

  String _name;

  /// Gets the database name
  String get dbName => _name;

  b.Database _db;

  /// Returns the database handle
  b.Database get dbHandle => _db;

  /// Gets or sets whether the connection gets opened automatically
  bool autoOpen = true;

  bool enableMigration = false;

  /// Creates a new Instance
  Database(String name, {this.autoOpen = true, this.enableMigration = false}) {
    _name = name;

    if (this.autoOpen) {
      PomLogger.instance.log.d("Auto-opening database '$name'");
      open();
    }
  }

  Future<void> _doMigrations() async {
    _migrationContext = ModelContext<$MigrationInfo>(this, _migrationInfo);
    await _migrationContext.create();

    _tables.forEach((t, v) async {
      var table = _tables[t];

      PomLogger.instance.log.d("*** Running Migration for '${table.tableName}' ***");

      var tableInfo =
        await _migrationContext.select((q) {
          return q.where(_migrationContext.fields.name.equals(table.tableName));
        });

      /// If there is exactly one entry inside the model cache table
      if (tableInfo.length == 1) {
        /// Get item
        var migrationInfo = tableInfo.first;

        /// if the table revision > than the stored revision
        if (migrationInfo.tableRevision.value < table.revision) {
          /// run migration for every revision between current and target
          for (var migrateVersion = migrationInfo.tableRevision.value;
              migrateVersion <= table.revision;
              migrateVersion++) {
            PomLogger.instance.log.d("Migrating '${table.tableName}' from Revision ${migrationInfo.tableRevision.value} to $migrateVersion ...");
            await table.migrate(MigrationContext(this, table),
                migrationInfo.tableRevision.value, migrateVersion);
            migrationInfo.tableRevision.value = migrateVersion;
            await _migrationContext.update(migrationInfo);
          }
        } else if (migrationInfo.tableRevision.value > table.revision) {
          throw AssertionError(
              "The table metadata for '${table.tableName}' are ahead of table the actual revision");
        }
        /// If there is no model cached we create a new entry
      } else if (tableInfo.length == 0) {
        PomLogger.instance.log..i("No model cache found for table ${table.tableName}.");
        var newMigrationInfo = $MigrationInfo();
        newMigrationInfo.name.value = table.tableName;
        newMigrationInfo.tableRevision.value = table.revision;
        await _migrationContext.put(newMigrationInfo);
        /// if there is more than one model, this is no good!
      } else if (tableInfo.length > 1) {
        print("There is more than one migration info. Removing all from database. Please restart the app.");
        await _migrationContext.deleteAll();
      }
    });
  }

  Future<void> _initializeDatabase() async {
    _tables = initializeDatabase();

    if (_tables == null) {
      throw AssertionError("There was no table defined for the database.");
    }

    if (enableMigration) {
      await _doMigrations();
    }
  }

  /// Initializes the database
  Map<Type, Table> initializeDatabase();

  /// Returns the table for the requested model type
  Future<BaseModelContext<T>> of<T extends Table>() async {
    if (_modelTables.containsKey(T)) {
      return (_modelTables[T] as BaseModelContext<T>);
    }

    var context = ModelContext<T>(this, _tables[T]);
    await context.create(false);
    _modelTables[T] = context;

    return context;
  }

  /// opens the database connection
  Future<void> open() async {
    _db = await b.openDatabase(dbName);
    await _initializeDatabase();
  }

  /// Close the connection
  Future<void> close() async {
    return _db.close();
  }
}
