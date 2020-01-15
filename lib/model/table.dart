library flutter_pom;

import 'package:flutter_pom/model/database.dart';
import 'package:flutter_pom/model/field.dart';

abstract class Table {

  String _name;
  /// Returns the table name
  String get tableName => _name;

  /// Returns the fields
  List<Field> _fields;
  /// Returns the fields
  List<Field> get fields => _fields;

  Table(String tableName) {
    _name = tableName;
    _initializeFields();
  }

  Field get idField {
    return _fields.firstWhere((f) => f.isPrimaryKey);
  }

  /// initializes all fields
  void _initializeFields() {
    _fields = initializeFields();
    if (_hasDuplicatePrimaryKey) {
      throw UnsupportedError("You have defined multiple primary keys for your database which is currently not supported.");
    }

    if (!_hasPrimaryKey) {
      throw UnsupportedError("You have to define at least on 'primary key' inside your table.");
    }
  }

  List<Field> initializeFields();

  /// Returns if there is more than one primary key
  bool get _hasDuplicatePrimaryKey {
    var fields = _fields.where((f) => f.isPrimaryKey);
    if (fields == null) return false;
    return fields.length > 1;
  }

  /// Returns if there is a primary key defined
  bool get _hasPrimaryKey {
    return _fields.any((f) => f.isPrimaryKey);
  }

  Field _getField(String name) {
    return _fields.firstWhere((f) => f.name == name);
  }

  Table getInstance();

  /* Abstract Members */
  static Table map(Map<String, dynamic> data, Table table) {
    for (var key in data.keys) {
      var field = table._getField(key);
      field.fromSqlCompatibleValue(data[key].toString());
    }
    return table;
  }
}