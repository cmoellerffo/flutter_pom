library flutter_pom;

import 'package:flutter_pom/context/migration_context.dart';
import 'package:flutter_pom/errors/field_constraint_error.dart';
import 'package:flutter_pom/errors/missing_field_error.dart';
import 'package:flutter_pom/errors/missing_primary_key_error.dart';
import 'package:flutter_pom/errors/multiple_primary_key_error.dart';
import 'package:flutter_pom/flutter_pom.dart';
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

    if (_hasDuplicateField) {
      throw DuplicateFieldError(this, "Field names have to be unique.");
    }
    if (_hasDuplicatePrimaryKey) {
      throw MultiplePrimaryKeyError(this);
    }
    if (!_hasPrimaryKey) {
      throw MissingPrimaryKeyError(this);
    }
  }

  /// Returns whether there are duplicate fields defined
  bool get _hasDuplicateField {
    for (var field in _fields) {
      if (_fields.where((f) => f.name == field.name).length > 1) {
        return true;
      }
    }
    return false;
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
    if (!_fields.any((f) => f.name == name)) return null;
    return _fields.firstWhere((f) => f.name == name);
  }

  /// Creates a new instance
  Table getInstance();

  /// Initializes all fields
  List<Field> initializeFields();

  /// Gets the revision
  int get revision;

  /// Migrates the table
  Future<void> migrate(
      MigrationContext context, int fromRevision, int toRevision) async {
    var newFields = _fields.where((f) => f.revision == toRevision);
    if (newFields != null && newFields.length > 0) {
      for (var field in _fields) {
        context.addField(field);
      }
    }
  }

  /* Static Members */
  /// Maps values to an instance of a Dataset
  static Table map(Map<String, dynamic> data, Table table) {
    for (var key in data.keys) {
      var field = table._getField(key);

      if (field == null) {
        throw MissingFieldError(
            table, 'Cannot map data to field "$key". Field was not found.');
      }

      if (data[key] != null) {
        try {
          field.fromSqlCompatibleValue(data[key]);
        } catch (e) {
          throw FieldConstraintError(field,
              'Cannot map data to field "${field.name}". ${e.toString()}');
        }
      } else {
        field.fromSqlCompatibleValue(null);
      }
    }
    return table;
  }
}
