import 'package:flutter_pom/errors/field_constraint_error.dart';
import 'package:flutter_pom/model/field.dart';

class BoolField extends Field<bool> {
  BoolField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(dynamic value) {
    if (value is bool) {
      this.value = value;
    } else if (value is int) {
      this.value = (value > 0);
    } else if (value is String) {
      this.value = (value.toLowerCase() == "true");
    } else throw FieldConstraintError(this, "The value cannot be parsed to bool");
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

  @override
  bool get supportsPrimaryKey => false;

  @override
  bool get defaultValue => false;

}