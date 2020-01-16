import 'package:flutter_pom/model/field.dart';

class DoubleField extends Field<double> {
  DoubleField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(String value) {
    init(double.parse(value));
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
  bool get supportsPrimaryKey => false;

  @override
  double get defaultValue => 0;

}