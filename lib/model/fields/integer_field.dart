import 'package:flutter_pom/model/field.dart';

class IntegerField extends Field<int> {
  IntegerField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(dynamic value) {
    this.value = value;
  }

  @override
  String toSqlCompatibleValue() {
    return value.toString();
  }

  @override
  bool supportsAutoIncrement() {
      return true;
  }

  @override
  // TODO: implement sqlType
  String get sqlType => "INTEGER";

  @override
  bool get supportsPrimaryKey => true;

  @override
  int get defaultValue => 0;

}