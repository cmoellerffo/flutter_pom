import 'package:flutter/widgets.dart';
import 'package:flutter_pom/flutter_pom.dart' as pom;
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as m;

import 'flutter_pom_test_table.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  group('flutter_pom', () {
    // Check that public api are exported
    test('package export availability', () {
      <dynamic>[
        pom.Database,
        pom.Table,
        pom.IntegerField,
        pom.DoubleField,
        pom.DateTimeField,
        pom.BoolField,
        pom.StringField,
        pom.IdField,
        pom.SecureStringField,
        pom.FieldConstraintError,
        pom.MissingPrimaryKeyError,
        pom.MultiplePrimaryKeyError,
        pom.TableConfigurationError
      ].forEach((dynamic value) {
        expect(value, isNotNull);
      });
    });

    // Check the id field constraints
    test('IdField constraints', () {
      pom.IdField idField = pom.IdField("id");

      assert(idField.name == "id");
      assert(idField.isPrimaryKey);
      assert(!idField.isAutoIncrement);
    });

    // Check generic field constraints
    test('Primary Keys field constraints', () {
      <pom.Field>[
        pom.StringField("string_field"),
        pom.SecureStringField("secure_string_field"),
        pom.DateTimeField("datetime_field"),
        pom.DoubleField("double_field")
      ].forEach((field) {
        expect(() => field.primaryKey(), throwsA(const m.TypeMatcher<pom.FieldConstraintError>()));
      });
    });

    // Check Secure String field
    test('Autoincrement field constraints', () {
      <pom.Field>[
        pom.StringField("string_field"),
        pom.SecureStringField("secure_string_field"),
        pom.DateTimeField("datetime_field"),
        pom.BoolField("bool_field")
      ].forEach((field) {
        expect(() => field.autoIncrement(), throwsA(const m.TypeMatcher<pom.FieldConstraintError>()));
      });
    });

    // Check table constraints
    test('Table setup', () {
      var table = FlutterPomTestTable();

      expect(table.idField, isInstanceOf<pom.IdField>());
      assert(table.idField == table.id);
      assert(table.fields.length > 0);
    });

    // Test field value mapping
    test('Field "id" mapping', () {
      var table = FlutterPomTestTable();

      pom.Table.map({
        "id": 1,
      }, table);

      assert(table.id.value == 1);
    });

    // Test field value mapping
    test('Field "int_field" mapping', () {
      var table = FlutterPomTestTable();

      pom.Table.map({
        "int_field": 5,
      }, table);

      assert(table.intField.value == 5);
    });

    // Test field value mapping
    test('Field "string_field" mapping', () {
      var table = FlutterPomTestTable();

      pom.Table.map({
        "string_field": "string",
      }, table);

      assert(table.stringField.value == "string");
    });

    // Test field value mapping
    test('Field "string_not_null" mapping', () {
      var table = FlutterPomTestTable();

      pom.Table.map({
        "string_not_null": "string",
      }, table);

      assert(table.notNullField.value == "string");
    });

    // Test field value mapping
    test('Field "string_not_null" NULL value', () {
      var table = FlutterPomTestTable();

      assert(table.notNullField.value != null);
      expect(() => pom.Table.map({"string_not_null": null}, table), throwsA(m.TypeMatcher<pom.FieldConstraintError>()));
      assert(table.notNullField.value != null);

      assert(!table.notNullField.dirty);
    });

    // Test field value mapping
    test('Field "datetime_field" mapping', () {
      var table = FlutterPomTestTable();

      expect(pom.Table.map({"datetime_field": "2019-01-01 10:10:10"}, table), isInstanceOf<pom.Table>());

      assert(table.dateTimeField.value.year == 2019);
      assert(table.dateTimeField.value.month == 1);
      assert(table.dateTimeField.value.day == 1);
      assert(table.dateTimeField.value.hour == 10);
      assert(table.dateTimeField.value.minute == 10);
      assert(table.dateTimeField.value.second == 10);

      assert(table.dateTimeField.dirty);
    });
  });
}