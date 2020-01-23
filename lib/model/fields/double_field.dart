import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';

class DoubleField extends Field<double> {
  DoubleField(String name) : super(name);

  @override
  void fromSqlCompatibleValue(dynamic value) {
    if (value == double.infinity || value == double.negativeInfinity) {
      throw UnsupportedError("Infinity values are not supported by SQL Framework");
    }
    if (value == double.nan) {
      throw UnsupportedError("NaN values are not supported for DoubleField.");
    }
    if (value is String) {
      value = double.parse(value);
    } else {
      this.value = value;
    }
  }

  @override
  String get sqlType => SQLTypes.double;

  @override
  bool supportsAutoIncrement() {
    return true;
  }

  @override
  String toSql(v) {
    if (v == double.infinity || v == double.negativeInfinity) {
      return '0';
    }
    return v.toString();
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  double get defaultValue => 0;

}