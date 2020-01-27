import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/model/sql_types.dart';

class ObjectField<T extends Serializable> extends Field {
  ObjectField(String name) : super(name);

  @override
  get defaultValue => null;

  @override
  bool get supportsPrimaryKey => false;

  @override
  String get sqlType => SQLTypes.text;

  @override
  void fromSqlCompatibleValue(value) {
    if (value is T) {
      this.value = value;
    } else {}
  }

  @override
  String toSql(v) {
    var retVal = v.toJson();
    return "'$retVal'";
  }

  @override
  bool supportsAutoIncrement() {
    return false;
  }
}
