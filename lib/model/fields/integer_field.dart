import 'package:flutter_pom/model/field.dart';

class IntegerField extends Field<int> {
  IntegerField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(String value) {
    init(int.parse(value));
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

}