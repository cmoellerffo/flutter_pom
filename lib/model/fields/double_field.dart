import 'package:flutter_pom/model/field.dart';

class DoubleField extends Field<double> {
  DoubleField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(dynamic value) {
    this.value = value;
  }

  @override
  String get sqlType => "DOUBLE";

  @override
  bool supportsAutoIncrement() {
    return true;
  }

  @override
  String toSqlCompatibleValue() {
    return value.toString();
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  double get defaultValue => 0;

}