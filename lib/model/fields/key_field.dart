import 'package:flutter_pom/flutter_pom.dart';

class KeyField extends Field<Field> {
  KeyField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(String value) {
    // TODO: implement fromSqlCompatibleValue
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
    // TODO: implement toSqlCompatibleValue
    return null;
  }

}