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
