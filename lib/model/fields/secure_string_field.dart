import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_pom/model/field.dart';

class SecureStringField extends Field<String> {
  SecureStringField(String name) : super(name);

  @override
  set value(String value) {
    super.value = _sha1(value);
  }

  @override
  void fromSqlCompatibleValue(String value) {
    this.value = value;
  }

  @override
  String toSqlCompatibleValue() {
    return "'$value'";
  }

  @override
  String get sqlType => 'TEXT';

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  bool operator ==(secureString) {
    return _sha1(secureString).toString() == this.value;
  }

  String _sha1(String insecure) {
    var bytes = utf8.encode(value);
    var sha = sha1.convert(bytes);
    return sha.toString();
  }

  @override
  bool get supportsPrimaryKey => false;

  @override
  String get defaultValue => "";
}