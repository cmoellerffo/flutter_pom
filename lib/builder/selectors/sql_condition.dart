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

import 'package:flutter_pom/builder/selectors/sql_selector.dart';
import 'package:flutter_pom/flutter_pom.dart';

class SQLCondition extends SQLSelector {
  Field field;
  SQLComparators comparator;
  dynamic value;

  SQLLogicOperator operator = SQLLogicOperator.none;
  SQLCondition child;

  SQLCondition(this.field, this.comparator, this.value);

  @override
  String toSql() {
    String comparatorValue;
    String operatorValue = "";
    var builder = <String>[];

    switch (comparator) {
      case SQLComparators.Equals:
        comparatorValue = SQLTypes.eq;
        break;
      case SQLComparators.Greater:
        comparatorValue = SQLTypes.gt;
        break;
      case SQLComparators.Lower:
        comparatorValue = SQLTypes.lt;
        break;
      case SQLComparators.GreaterOrEqual:
        comparatorValue = SQLTypes.gt + SQLTypes.eq;
        break;
      case SQLComparators.LowerOrEqual:
        comparatorValue = SQLTypes.lt + SQLTypes.eq;
        break;
      case SQLComparators.Like:
        comparatorValue = SQLTypes.like;
        break;
      case SQLComparators.NotEquals:
        comparatorValue = SQLTypes.not + SQLTypes.eq;
    }

    switch (operator) {
      case SQLLogicOperator.and:
        operatorValue = SQLKeywords.and;
        break;
      case SQLLogicOperator.or:
        operatorValue = SQLKeywords.or;
        break;
      default:
        break;
    }

    builder.addAll(
        [operatorValue, field.name, comparatorValue, field.toSql(value)]);

    if (child != null) {
      builder.add(child.toSql());
    }

    return builder.join(SQLTypes.separator);
  }

  SQLCondition and(SQLCondition condition) {
    child = condition;
    child.operator = SQLLogicOperator.and;
    return this;
  }

  SQLCondition or(SQLCondition condition) {
    child = condition;
    child.operator = SQLLogicOperator.or;
    return this;
  }
}

enum SQLLogicOperator { none, and, or }
