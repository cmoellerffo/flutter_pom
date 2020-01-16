library flutter_pom;

import 'package:flutter_pom/errors/missing_primary_key_error.dart';
import 'package:flutter_pom/errors/multiple_primary_key_error.dart';
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

  /// Returns the idField for this table
  Field get idField {
    return _fields.firstWhere((f) => f.isPrimaryKey);
  }

  /// initializes all fields
  void _initializeFields() {
    _fields = initializeFields();
    if (_hasDuplicatePrimaryKey) {
      throw MultiplePrimaryKeyError(this);
    }
    if (!_hasPrimaryKey) {
      throw MissingPrimaryKeyError(this);
    }
  }


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

  /// Creates a new instance
  Table getInstance();

  /// Initializes all fields
  List<Field> initializeFields();

  /* Static Members */
  static Table map(Map<String, dynamic> data, Table table) {
    for (var key in data.keys) {
      var field = table._getField(key);
      if (data[key] != null) {
        field.fromSqlCompatibleValue(data[key].toString());
      } else {
        field.fromSqlCompatibleValue(null);
      }
    }
    return table;
  }
}