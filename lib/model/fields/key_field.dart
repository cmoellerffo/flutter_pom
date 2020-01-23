import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/model/sql_types.dart';

class KeyField<T extends Table> extends IntegerField {
  KeyField(String name, T binding) : super(name) {
    this.binding = binding;
  }

  T binding;

  @override
  void fromSqlCompatibleValue(dynamic value) {
    this.value = value;
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
    return binding.idField.value;
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  int get defaultValue => 0;

}