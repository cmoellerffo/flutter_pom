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

import 'package:flutter_pom/errors/field_constraint_error.dart';
import 'package:flutter_pom/flutter_pom.dart';

/// Abstract Table Field implementation.
///
/// You can create your own field types by deriving from this class like
///
/// ´´´dart
/// class MyField extends Field<MyType> {
/// ...
/// }
/// ´´´
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
      throw FieldConstraintError(
          this, "Unable to set NULL to a NOT NULL field.");
    } else {
      _value = value;
      markDirty();
    }
  }

  T _defaultValue;
  T get defaultValue => _defaultValue;

  bool _idxUnique = false;
  /// Gets whether the index is unique or not
  bool get idxUnique => _idxUnique;

  bool _idxCreate = false;
  /// Gets whether there will be an index
  bool get idxCreate => _idxCreate;

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

  /// Adds an index to the configured field and sets whether
  /// the index values shall be [unique]
  Field withIndex({bool unique = false}) {
    _idxCreate = true;
    _idxUnique = unique;
    return this;
  }

  /// Sets the field as primary key
  Field primaryKey() {
    if (supportsPrimaryKey) {
      _primaryKey = true;
      return this;
    } else {
      throw FieldConstraintError(
          this, "This field cannot be made a primary key");
    }
  }

  /// Sets the fields requirement to NOT NULL
  Field notNull(T defaultValue) {
    _defaultValue = defaultValue;
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
      throw FieldConstraintError(
          this, "The field does not support auto increment");
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

  SQLCondition compare(dynamic value, SQLComparators comparator) {
    return SQLCondition(this, comparator, value);
  }

  SQLCondition compareField(Field field, SQLComparators comparator) {
    return compare(field.toSqlCompatibleValue(), comparator);
  }

  SQLCondition equals(dynamic value) {
    return compare(value, SQLComparators.Equals);
  }

  SQLCondition equalsField(Field value) {
    return compare(value.toSqlCompatibleValue(), SQLComparators.Equals);
  }

  SQLCondition notEquals(dynamic value) {
    return compare(value, SQLComparators.NotEquals);
  }

  SQLCondition notEqualsField(Field field) {
    return compare(field.toSqlCompatibleValue(), SQLComparators.NotEquals);
  }

  SQLCondition gt(dynamic value) {
    return compare(value, SQLComparators.Greater);
  }

  SQLCondition gte(dynamic value) {
    return compare(value, SQLComparators.GreaterOrEqual);
  }

  SQLCondition lt(dynamic value) {
    return compare(value, SQLComparators.Lower);
  }

  SQLCondition lte(dynamic value) {
    return compare(value, SQLComparators.LowerOrEqual);
  }
}
