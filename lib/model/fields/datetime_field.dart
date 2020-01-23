import 'package:flutter_pom/errors/field_constraint_error.dart';
import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';
import 'package:intl/intl.dart';

class DateTimeField extends Field<DateTime> {
  DateTimeField(String name) : super(name);

  final String sqlDateFormat = "yyyy-MM-dd HH:mm:ss";

  @override
  void fromSqlCompatibleValue(dynamic value) {
    if (value == null) {
      this.value = null;
    } else if (value is String) {
      this.value = DateFormat(sqlDateFormat).parse(value.toString());
    } else if (value is DateTime) {
      this.value = value;
    } else if (value is int) {
      this.value = DateTime.fromMillisecondsSinceEpoch(value);
    } else {
      throw new FieldConstraintError(this, "Unable to convert value to DateTime.");
    }
  }

  @override
  // TODO: implement sqlType
  String get sqlType => SQLTypes.dateTime;

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  DateTime get defaultValue => DateTime.now();

  @override
  String toSql(v) {
    if (v == null) {
      return SQLTypes.nullValue;
    }
    else {
      return SQLTypes.toSqlString(DateFormat(sqlDateFormat).format(v));
    }
  }

}