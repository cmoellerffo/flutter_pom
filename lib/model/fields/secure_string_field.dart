import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';

class SecureStringField extends Field<String> {
  SecureStringField(String name) : super(name);

  @override
  set value(String value) {
    super.value = _sha1(value);
  }

  @override
  void fromSqlCompatibleValue(dynamic value) {
    super.value = value;
  }

  @override
  String toSql(v) {
    return SQLTypes.toSqlString(v);
  }

  @override
  String get sqlType => SQLTypes.text;

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  bool equalsString(String insecure) {
    return this.value == _sha1(insecure);
  }

  String _sha1(String insecure) {
    var bytes = utf8.encode(insecure);
    var sha = sha1.convert(bytes);
    return sha.toString();
  }

  @override
  bool get supportsPrimaryKey => false;

  @override
  String get defaultValue => "";
}
