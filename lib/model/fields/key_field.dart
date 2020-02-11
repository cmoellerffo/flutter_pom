import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/model/sql_types.dart';

class KeyField<T extends Table> extends IntegerField {
  KeyField(String name) : super(name);

  T _binding;
  T get binding => _binding;
  set binding(T value) {
    _binding = value;
    itemKey = value.idField.value;
  }

  /// Gets or sets the itemKey
  int itemKey = -1;

  @override
  void fromSqlCompatibleValue(dynamic value) {
    itemKey = value;
  }

  @override
  String get sqlType => SQLTypes.integer;

  @override
  Field primaryKey() {
    throw new UnsupportedError("A Key field cannot be a primary key");
  }

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  String toSqlCompatibleValue() {
    return itemKey.toString();
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  int get defaultValue => 0;
}
