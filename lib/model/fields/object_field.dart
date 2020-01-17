import 'dart:convert';

import 'package:flutter_pom/flutter_pom.dart';

class ObjectField<T extends Serializable> extends Field {
  ObjectField(String name) : super(name);

  @override
  get defaultValue => null;

  @override
  bool get supportsPrimaryKey => false;

  @override
  String get sqlType => "TEXT";

  @override
  void fromSqlCompatibleValue(value) {
    if (value is T) {
      this.value = value;
    } else {
    }
  }

  @override
  String toSqlCompatibleValue() {
    var retVal = value.toJson();
    return "'$retVal'";
  }

  @override
  bool supportsAutoIncrement() {
    return false;
  }

}