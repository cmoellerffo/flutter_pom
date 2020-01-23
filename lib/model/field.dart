import 'package:flutter_pom/errors/field_constraint_error.dart';

abstract class Field<T> {

  String _name;
  /// Gets the name of the field
  String get name => _name;

  T _value;
  /// Gets the value
  T get value => _value;
  /// Sets the value
  set value(T value) {
    if (value == null && isNotNull) {
      throw FieldConstraintError(this, "Unable to set NULL to a NOT NULL field.");
    } else {
      _value = value;
      markDirty();
    }
  }

  bool _dirty = false;
  /// Gets whether the field was modified
  bool get dirty => _dirty;

  bool _primaryKey = false;
  /// Gets whether the field is a primary key
  bool get isPrimaryKey => _primaryKey;

  bool _autoIncrement = false;
  /// Gets whether the field is a auto increment field
  bool get isAutoIncrement => _autoIncrement;

  bool _notNull = false;
  /// Gets whether the field is marked as NOT NULL
  bool get isNotNull => _notNull;

  int _revision = 1;
  /// Gets the create fields revision
  int get revision => _revision;


  /// Creates a new instance
  Field(this._name, [this._value]);

  /* Extension Methods */
  /// Sets the initial revision
  void atRevision(int revision) {
    _revision = revision;
  }

  /// Marks the field value as dirty
  void markDirty() {
    _dirty = true;
  }

  /// Sets the field as primary key
  Field primaryKey() {
    if (supportsPrimaryKey) {
      _primaryKey = true;
      return this;
    } else {
      throw FieldConstraintError(this, "This field cannot be made a primary key");
    }
  }

  /// Sets the fields requirement to NOT NULL
  Field notNull() {
    _notNull = true;
    if (value == null) {
      _value = defaultValue;
    }
    return this;
  }

  /// Sets the field as auto increment
  Field autoIncrement() {
    if (supportsAutoIncrement()) {
      _autoIncrement = true;
    } else {
      throw FieldConstraintError(this, "The field does not support auto increment");
    }
    return this;
  }

  /// Initialize the value
  init(T v) {
    this.value = v;
  }

  /* Abstract methods */
  String toSqlCompatibleValue() {
    return toSql(value);
  }

  void fromSqlCompatibleValue(dynamic value);

  String toSql(T value);

  /* Abstract getters */
  bool supportsAutoIncrement();
  bool get supportsPrimaryKey;
  String get sqlType;

  @override
  String toString() {
    return toSql(value);
  }

  T get defaultValue;
}