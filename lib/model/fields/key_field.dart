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
import 'package:flutter_pom/model/sql_types.dart';

class KeyField<T extends Table> extends IntegerField {
  KeyField(String name) : super(name);

  T _binding;
  T get binding => _binding;
  set binding(T value) {
    _binding = value;
    itemKey = value.idField.value;
  }

  /// Gets or sets the itemKey
  int itemKey = -1;

  @override
  void fromSqlCompatibleValue(dynamic value) {
    itemKey = value;
  }

  @override
  String get sqlType => SQLTypes.integer;

  @override
  Field primaryKey() {
    throw new UnsupportedError("A Key field cannot be a primary key");
  }

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  String toSqlCompatibleValue() {
    return itemKey.toString();
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  int get defaultValue => 0;
}
