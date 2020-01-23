import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';

class StringField extends Field<String> {
  StringField(String name) : super(name) {
    if (isNotNull) {
      init("");
    }
  }

  @override
  void fromSqlCompatibleValue(dynamic value) {
    this.value = value;
  }

  @override
  String toSql(v) {
    return SQLTypes.toSqlString(v);
  }

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  String get sqlType => SQLTypes.text;

  @override
  bool get supportsPrimaryKey => true;

  @override
  String get defaultValue => "";
}
