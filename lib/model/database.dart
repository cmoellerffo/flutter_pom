/*
BSD 2-Clause License

Copyright (c) 2020, VIVASECUR GmbH
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import 'dart:io';

import 'package:flutter_pom/context/base_model_context.dart';
import 'package:flutter_pom/context/base_model_transaction.dart';
import 'package:flutter_pom/context/migration_context.dart';
import 'package:flutter_pom/context/model_context.dart';
import 'package:flutter_pom/context/model_transaction.dart';
import 'package:flutter_pom/model/migration_info.dart';
import 'package:flutter_pom/model/table.dart';
import 'package:sqflite/sqflite.dart' as b;

/// Represents a physical SQLite Database containing [Table]s that are
/// built based on code-first column definition
///
/// Based on whether you want the provided [Database] to automatically
/// Migrate your [Table]s based on Revision numbers the [Database] will
/// try to add columns introduced in later revisions by creating the
/// corresponding '''ALTER TABLE''' statements.
///
/// - **DO** create a new [Database] model definition
///
/// '''dart
/// class MyDatabaseModel extends Database {
///
///   // Call super and provide the database name
///   MyDatabaseModel() : super('my_db.db');
///
///   // Return all tables that you want your database to contain
///   @override
///   Map<Type, Table> initializeDatabase() {
///     return <Type, Table> {
///       MySampleTable: MySampleTable()
///     };
///   }
/// }
/// '''
///
/// - **DON'T** return a variable list inside **initializeDatabase()** that
///   can change over time.
///
/// - **DON'T** use the **dbHandle** property to make modifications to your
///   tables as the [Database] will not track changes made directly.
///
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

  /// Gets or sets whether to do auto migration
  bool enableMigration = false;

  /// Creates a new Instance
  Database(String name, {this.enableMigration = true}) {
    _name = name;
  }

  /// Returns a new [ModelTransaction] transaction container for executing
  /// queries in a transactional way
  BaseModelTransaction transaction() {
    return ModelTransaction(this);
  }

  /// Runs the automatic migration of all [Table]s inside this [Database] by
  /// checking the automatically stored [$MigrationInfo] with the current
  /// [Table] revision.
  ///
  /// When there is no [$MigrationInfo] available for a [Table], a new
  /// migration will be executed for the selected [Table]
  ///
  /// - **KEEP IN MIND** that we currently only support **Adding Columns**
  ///
  Future<void> _doMigrations({bool force = false}) async {
    print("INFO: Running migrations ...");
    _migrationContext = ModelContext<$MigrationInfo>(this, _migrationInfo);
    await _migrationContext.create();

    if (force) {
      print("WARNING: Migration of tables forced!");
    }

    for(var t in _tables.keys) {
      var table = _tables[t];
      print("DEBUG: Found Table ${table.tableName} with Target-Revision: ${table.revision}");
      
      var tableInfo =
        await _migrationContext.select((q) {
          return q.where(_migrationContext.fields.name.equals(table.tableName));
        });
      
      print("DEBUG: Stored Table Revision count: ${tableInfo.length}");

      if (tableInfo.length > 1) {
        print("INFO: Repairing mismatch Migration Table Info ...");

        tableInfo.sort((a, b) => a.tableRevision.value.compareTo(b.tableRevision.value));

        for (var i = 0; i < tableInfo.length - 1; ++i) {
          print(" ... Deleting migration info for Revision ${tableInfo[i].tableRevision.value}");
          await _migrationContext.deleteEntity(tableInfo[i]);
        }
      }

      /// If there is exactly one entry inside the model cache table
      if (tableInfo.length == 1 || force) {
        /// Get item
        var migrationInfo = tableInfo.first;

        print("DEBUG: Stored Table Revision: ${migrationInfo.tableRevision.value}");

        /// if the table revision > than the stored revision
        if (migrationInfo.tableRevision.value < table.revision || force) {
          if (force) {
            migrationInfo.tableRevision.value = 1;
          }
          /// run migration for every revision between current and target
          print("INFO: Migrating '$dbName.${table.tableName}' from Revision ${migrationInfo.tableRevision.value} to ${table.revision} ...");
          await _migrateTable(migrationInfo, table);
        } else if (migrationInfo.tableRevision.value > table.revision) {
          throw AssertionError(
              "The table metadata for '${table.tableName}' are ahead of the current table revision");
        }
        /// If there is no model cached we create a new entry
      } else if (tableInfo.length == 0) {
        print("INFO: No model cache found for table ${table.tableName}. If this is the first execution this is the predicted behaviour.");
        var newMigrationInfo = $MigrationInfo();
        newMigrationInfo.name.value = table.tableName;
        newMigrationInfo.tableRevision.value = table.revision;
        await _migrationContext.put(newMigrationInfo);
        print("INFO: Table '$dbName.${table.tableName}' was unversioned before. Skipping first-time migration.'");
      } else if (tableInfo.length > 1) {
        print("ERROR: There is more than one migration info. Removing all from database. Please restart the app.");
        await _migrationContext.delete((q) {
          return q.where(_migrationContext.fields.name.equals(table.tableName));
        });
      }
    }
  }

  Future<void> _migrateTable($MigrationInfo migrationInfo, Table table) async {
    for (var migrateVersion = migrationInfo.tableRevision.value + 1;
    migrateVersion <= table.revision;
    migrateVersion++) {
      print("... Revision update $migrateVersion.");
      await table.migrate(MigrationContext(this, table),
          migrationInfo.tableRevision.value, migrateVersion);

      migrationInfo.tableRevision.value = migrateVersion;

      // This hack is introduced as multiple revisions make problems on put updates.
      // We don't know the ID of the field after updating, what makes things very tricky

      await _migrationContext.delete((q) {
        return q.where(_migrationContext.fields.name.equals(table.tableName));
      });

      // Lets insert the newly generated table info into the context
      await _migrationContext.put(migrationInfo);
    }
  }

  Future<void> _initializeDatabase() async {
    print("INFO: Initializing database ...");
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

  /// Forcefully migrate tables (replay all migrations)
  /// This will eventually lead to some SQL errors due to duplicate field
  /// names. But it will help keeping old DB versions data intact when
  /// developers get confused about their changes.
  Future<void> forceMigration() async {
    await _doMigrations(force: true);
  }

  /// Close the connection
  Future<void> close() async {
    return _db.close();
  }

  /// Delete the database
  Future<void> delete() async {
    return await File(dbName).delete();
  }

  /// Enables the migration for all tables
  void enableMigrations() {
    enableMigration = true;
  }
  /// Disables the migration for all tables
  void disableMigrations() {
    enableMigration = false;
  }
}
