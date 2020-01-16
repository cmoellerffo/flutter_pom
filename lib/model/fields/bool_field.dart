import 'package:flutter_pom/model/field.dart';

class BoolField extends Field<bool> {
  BoolField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(String value) {
    this.value = (int.parse(value) > 0);
  }

  @override
  String get sqlType => "INTEGER";

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  String toSqlCompatibleValue() {
    return (this.value ? "1" : "0");
  }

}