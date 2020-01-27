import 'package:flutter_pom/errors/field_constraint_error.dart';
import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';

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
    } else
      throw FieldConstraintError(this, "The value cannot be parsed to bool");
  }

  @override
  String get sqlType => SQLTypes.boolean;

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  bool get supportsPrimaryKey => false;

  @override
  bool get defaultValue => false;

  @override
  String toSql(bool f) {
    return (f ? "1" : "0");
  }
}
