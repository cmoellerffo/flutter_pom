import 'package:flutter_pom/model/field.dart';
import 'package:intl/intl.dart';

class DateTimeField extends Field<DateTime> {
  DateTimeField(String name) : super(name);

  final String sqlDateFormat = "yyyy-MM-dd HH:mm:ss";

  @override
  void fromSqlCompatibleValue(dynamic value) {
    this.value = DateFormat(sqlDateFormat).parse(value.toString());
  }

  @override
  // TODO: implement sqlType
  String get sqlType => "DATETIME";

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  String toSqlCompatibleValue() {
    return DateFormat(sqlDateFormat).format(value);
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  DateTime get defaultValue => DateTime.now();

}