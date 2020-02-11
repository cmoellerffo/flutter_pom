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

import 'package:flutter_pom/errors/field_constraint_error.dart';
import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';
import 'package:intl/intl.dart';

class DateTimeField extends Field<DateTime> {
  DateTimeField(String name) : super(name);

  final String sqlDateFormat = "yyyy-MM-dd HH:mm:ss";

  @override
  void fromSqlCompatibleValue(dynamic value) {
    if (value == null) {
      this.value = null;
    } else if (value is String) {
      this.value = DateFormat(sqlDateFormat).parse(value.toString());
    } else if (value is DateTime) {
      this.value = value;
    } else if (value is int) {
      this.value = DateTime.fromMillisecondsSinceEpoch(value);
    } else {
      throw new FieldConstraintError(
          this, "Unable to convert value to DateTime.");
    }
  }

  @override
  String get sqlType => SQLTypes.dateTime;

  @override
  bool supportsAutoIncrement() {
    return false;
  }

  @override
  bool get supportsPrimaryKey => true;

  @override
  DateTime get defaultValue => DateTime.now();

  @override
  String toSql(v) {
    if (v == null) {
      return SQLTypes.nullValue;
    } else {
      return SQLTypes.toSqlString(DateFormat(sqlDateFormat).format(v));
    }
  }
}
