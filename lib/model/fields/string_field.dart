import 'package:flutter_pom/model/field.dart';

class StringField extends Field<String> {
  StringField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(String value) {
    this.value = value;
  }

  @override
  String toSqlCompatibleValue() {
    return "'$value'";
  }

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  String get sqlType => "VARCHAR(255)";

}