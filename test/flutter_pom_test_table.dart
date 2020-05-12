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

import 'package:flutter_pom/flutter_pom.dart';

class KeyValuePair implements Serializable {
  String key = "a";
  String value = "b";

  KeyValuePair(this.key, this.value);

  @override
  void fromJson(String value) {
  }

  @override
  Map<String, String> toJson() {
    return null;
  }
}

class FlutterPomTestTable extends Table {
  FlutterPomTestTable() : super("flutter_pom_test");

  IdField id = IdField("id").autoIncrement();

  IntegerField intField = IntegerField("int_field");

  StringField stringField = StringField("string_field");

  StringField notNullField = StringField("string_not_null").notNull("");

  BoolField boolField = BoolField("bool_field");

  DateTimeField dateTimeField = DateTimeField("datetime_field");

  DoubleField doubleField = DoubleField("double_field");

  ObjectField<KeyValuePair> objectField = ObjectField<KeyValuePair>("object_field");

  SecureStringField secureStringField = SecureStringField("secure_string");

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
      doubleField,
      objectField,
      secureStringField
    ];
  }

  @override
  int get revision => 1;
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

  @override
  int get revision => 1;
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

  @override
  int get revision => 1;
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

  @override
  int get revision => 1;
}