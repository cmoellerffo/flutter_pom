import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';

class IntegerField extends Field<int> {
  IntegerField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(dynamic value) {
    this.value = value;
  }

  @override
  String toSql(v) {
    return v.toString();
  }

  @override
  bool supportsAutoIncrement() {
      return true;
  }

  @override
  String get sqlType => SQLTypes.integer;

  @override
  bool get supportsPrimaryKey => true;

  @override
  int get defaultValue => 0;

}