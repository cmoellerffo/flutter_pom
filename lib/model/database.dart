import 'package:flutter_pom/model/base_model_context.dart';
import 'package:flutter_pom/model/model_context.dart';
import 'package:flutter_pom/model/table.dart';
import 'package:sqflite/sqflite.dart' as b;

abstract class Database {

  String _name;
  /// Gets the database name
  String get dbName => _name;

  Map<Type, Table> _tables;
  Map<Type, Table> initializeDatabase();
  Map<Type, ModelContext> _modelTables = <Type, ModelContext>{};

  b.Database _db;
  /// Returns the database handle
  b.Database get dbHandle => _db;

  bool autoOpen = true;

  /// Creates a new Instance
  Database(String name, {this.autoOpen = true}) {
    _name = name;
    if (this.autoOpen) {
      open();
    }
  }

  Future<void> _initializeDatabase() async {
    _tables = initializeDatabase();
  }

  /// Returns the table for the requested model type
  BaseModelContext<T> of<T extends Table>() {
    if (_modelTables.containsKey(T)) {
      return (_modelTables[T] as BaseModelContext<T>);
    }

    var context = ModelContext<T>(this, _tables[T]);
    context.create(false);
    _modelTables[T] = context;

    return context;
  }

  /// opens the database connection
  Future<void> open() async {
    _db = await b.openDatabase(dbName);
    await _initializeDatabase();
  }

}