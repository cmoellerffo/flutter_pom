import 'package:flutter_pom/model/field.dart';

import 'integer_field.dart';

class IdField extends IntegerField {
  IdField(String name) : super(name);

  @override
  bool get isPrimaryKey => true;

  @override
  Field primaryKey() {
    return this;
  }
}
