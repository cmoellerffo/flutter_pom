/*
BSD 2-Clause License

Copyright (c) 2020, VIVASECUR GmbH
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_pom/flutter_pom.dart' as pom;
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as m;
import 'flutter_pom_test_table.dart';

// Main Test entry point
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
        pom.ObjectField,
        pom.FieldConstraintError,
        pom.MissingPrimaryKeyError,
        pom.MultiplePrimaryKeyError,
        pom.TableConfigurationError,
        pom.MissingFieldError,
        pom.DuplicateFieldError
      ].forEach((dynamic value) {
        expect(value, isNotNull);
      });
    });


    // Check generic field constraints
    test('Primary Keys field constraints', () {
      <pom.Field>[
        pom.SecureStringField("secure_string_field"),
        pom.BoolField("bool_field")
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
        pom.BoolField("bool_field"),
        pom.ObjectField("object_field")
      ].forEach((field) {
        expect(() => field.autoIncrement(), throwsA(const m.TypeMatcher<pom.FieldConstraintError>()));
      });
    });

    // Check table constraints
    group('Table setup', () {
      var table = FlutterPomTestTable();

      test('Table index', () {
        expect(table.idField, isInstanceOf<pom.IdField>());
        assert(table.idField == table.id);
      });

      test('Multiple Primary keys', () {
        expect(() => FlutterPomTestTableDuplicateKey(),
            throwsA(m.TypeMatcher<pom.MultiplePrimaryKeyError>()));
      });
      test('Missing Primary keys', () {
        expect(() => FlutterPomTestTableMissingKey(),
            throwsA(m.TypeMatcher<pom.MissingPrimaryKeyError>()));
      });
      test('Duplicate Field names', () {
        expect(() => FlutterPomTestTableDuplicateName(),
            throwsA(m.TypeMatcher<pom.DuplicateFieldError>()));
      });
    });

    // Check the id field constraints
    test('Field "id" constraints', () {
      pom.IdField idField = pom.IdField("id");

      assert(idField.name == "id");
      assert(idField.isPrimaryKey);
      assert(!idField.isAutoIncrement);
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
    test('Field "int" mapping', () {
      var table = FlutterPomTestTable();

      pom.Table.map({
        "int_field": 5,
      }, table);

      assert(table.intField.value == 5);
    });

    // Test field value mapping
    test('Field "string" mapping', () {
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
    test('Field "datetime" mapping', () {
      var table = FlutterPomTestTable();

      expect(pom.Table.map({"datetime_field": "2019-01-01 10:10:10"}, table), isInstanceOf<pom.Table>());

      assert(table.dateTimeField.value.year == 2019);
      assert(table.dateTimeField.value.month == 1);
      assert(table.dateTimeField.value.day == 1);
      assert(table.dateTimeField.value.hour == 10);
      assert(table.dateTimeField.value.minute == 10);
      assert(table.dateTimeField.value.second == 10);

      assert(table.dateTimeField.dirty);

      expect(() => pom.Table.map({"datetime_field": 0.4}, table), throwsA(m.TypeMatcher<pom.FieldConstraintError>()));
      expect(pom.Table.map({"datetime_field": 12345678}, table), isInstanceOf<pom.Table>());
      expect(pom.Table.map({"datetime_field": DateTime.now()}, table), isInstanceOf<pom.Table>());
    });

    // Test field value mapping
    test('Field "bool" mapping', () {
      var table = FlutterPomTestTable();

      pom.Table.map({
        "bool_field": true,
      }, table);

      assert(table.boolField.value == true);

      pom.Table.map({
        "bool_field": 0,
      }, table);

      assert(table.boolField.value == false);

      pom.Table.map({
        "bool_field": "true",
      }, table);

      assert(table.boolField.value == true);
    });

    // Test field value mapping
    test('Field "double" mapping', () {
      var table = FlutterPomTestTable();

      pom.Table.map({
        "double_field": 0.3,
      }, table);

      assert(table.doubleField.value == 0.3);

      pom.Table.map({
        "double_field": "0.8"
      }, table);

      assert(table.doubleField.value == 0.3);

      //expect(() => pom.Table.map({"double_field": double.nan}, table), throwsA(m.TypeMatcher<UnsupportedError>()));
      //expect(() => pom.Table.map({"double_field": double.infinity}, table), throwsA(m.TypeMatcher<UnsupportedError>()));
      //expect(() => pom.Table.map({"double_field": double.negativeInfinity}, table), throwsA(m.TypeMatcher<UnsupportedError>()));
    });

    // Test field value mapping
    test('Field "unkown" mapping', () {
      var table = FlutterPomTestTable();

      expect(() => pom.Table.map({"unknown": "0.3"}, table), throwsA(m.TypeMatcher<pom.MissingFieldError>()));
    });

    // Test field value mapping
    test('Field "object" mapping', () {
      var table = FlutterPomTestTable();

      expect(pom.Table.map({"object_field": KeyValuePair('a', 'b')}, table), isInstanceOf<pom.Table>());
      //expect(() => pom.Table.map({"object_field": 128}, table), throwsA(m.TypeMatcher<pom.FieldConstraintError>()));
    });

    // Test secure string field
    test('Field "secure_string" mapping', () {
      var table = FlutterPomTestTable();
      const testString = "abcdef";

      pom.Table.map({
        "secure_string": testString
      }, table);

      assert(table.secureStringField.value == testString);

      table.secureStringField.value = testString;

      assert(table.secureStringField.value != testString);
      assert(table.secureStringField.equalsString(testString));
    });
  });
}