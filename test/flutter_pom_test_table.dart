import 'package:flutter_pom/flutter_pom.dart';

class FlutterPomTestTable extends Table {
  FlutterPomTestTable() : super("flutter_pom_test");

  IdField id = IdField("id").autoIncrement();

  IntegerField intField = IntegerField("int_field");

  StringField stringField = StringField("string_field");

  StringField notNullField = StringField("string_not_null").notNull();

  BoolField boolField = BoolField("bool_field");

  DateTimeField dateTimeField = DateTimeField("datetime_field");

  DoubleField doubleField = DoubleField("double_field");

  @override
  Table getInstance() {
    return FlutterPomTestTable();
  }

  @override
  List<Field> initializeFields() {
    return [
      id,
      intField,
      stringField,
      notNullField,
      boolField,
      dateTimeField,
      doubleField
    ];
  }
}


class FlutterPomTestTableDuplicateKey extends Table {
  FlutterPomTestTableDuplicateKey() : super("flutter_pom_test");

  IdField id = IdField("id").autoIncrement();

  IntegerField intField = IntegerField("int_field");

  StringField stringField = StringField("string_field").primaryKey();

  @override
  Table getInstance() {
    return FlutterPomTestTable();
  }

  @override
  List<Field> initializeFields() {
    return [
      id,
      intField,
      stringField,
    ];
  }
}

class FlutterPomTestTableMissingKey extends Table {
  FlutterPomTestTableMissingKey() : super("flutter_pom_test");

  IntegerField intField = IntegerField("int_field");

  StringField stringField = StringField("string_field");

  @override
  Table getInstance() {
    return FlutterPomTestTable();
  }

  @override
  List<Field> initializeFields() {
    return [
      intField,
      stringField,
    ];
  }
}

class FlutterPomTestTableDuplicateName extends Table {
  FlutterPomTestTableDuplicateName() : super("flutter_pom_test");

  IntegerField intField = IntegerField("int_field");

  StringField stringField = StringField("int_field");

  @override
  Table getInstance() {
    return FlutterPomTestTable();
  }

  @override
  List<Field> initializeFields() {
    return [
      intField,
      stringField,
    ];
  }
}