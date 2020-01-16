import 'package:flutter_pom/flutter_pom.dart';

class KeyField<T extends Table> extends IntegerField {
  KeyField(String name, T binding) : super(name) {
    this.binding = binding;
  }

  T binding;

  @override
  void fromSqlCompatibleValue(String value) {
    this.value = int.parse(value);
  }

  @override
  String get sqlType => "INTEGER";

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

}