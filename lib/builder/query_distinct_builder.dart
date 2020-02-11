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

import 'package:flutter_pom/builder/query_builder.dart';
import 'package:flutter_pom/builder/selectors/sql_condition.dart';
import 'package:flutter_pom/builder/selectors/sql_where_selector.dart';
import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';
import 'package:flutter_pom/model/table.dart';

class QueryDistinctBuilder extends QueryBuilder {
  SQLWhereSelector _whereSelector;
  List<Field> _orderBy;
  SQLSortOrder _sortOrder;
  Field _field;
  int _limit;
  int _offset;

  QueryDistinctBuilder(Table table, Field f) : super(table) {
    _field = f;
  }

  QueryDistinctBuilder where(SQLCondition condition) {
    if (_whereSelector != null)
      throw UnsupportedError("There is already a 'where' clause defined");

    _whereSelector = SQLWhereSelector(condition);
    return this;
  }

  QueryDistinctBuilder orderBy(SQLSortOrder order, List<Field> field) {
    if (_orderBy != null)
      throw UnsupportedError("There is already a 'orderBy' clause defined");
    _orderBy = field;
    _sortOrder = order;
    return this;
  }

  QueryDistinctBuilder orderByAsc(List<Field> fields) {
    orderBy(SQLSortOrder.Ascending, fields);
    return this;
  }

  QueryDistinctBuilder orderByDesc(List<Field> fields) {
    orderBy(SQLSortOrder.Descending, fields);
    return this;
  }

  QueryDistinctBuilder limit(int max) {
    if (_limit != null)
      throw UnsupportedError("There is already a 'limit' clause defined");
    _limit = max;
    return this;
  }

  QueryDistinctBuilder offset(int start) {
    if (_offset != null)
      throw UnsupportedError("There is already a 'offsert' clause defined");
    _offset = start;
    return this;
  }

  String toSql() {
    var builder = <String>[];
    builder.addAll([
      SQLKeywords.select,
      SQLKeywords.distinct,
      _field.name,
      SQLKeywords.from,
      table.tableName
    ]);

    if (_whereSelector != null) {
      builder.add(_whereSelector.toSql());
    }

    if (_orderBy != null) {
      var sortOrder = (_sortOrder == SQLSortOrder.Ascending)
          ? SQLKeywords.ascending
          : SQLKeywords.descending;
      if (_orderBy != null &&
          _orderBy.length != null &&
          _orderBy.any((f) => f != null)) {
        builder.addAll([
          SQLKeywords.orderBy,
          _orderBy.map((f) => f.name).join(SQLTypes.comma),
          sortOrder
        ]);
      }
    }

    if (_limit != null) {
      builder.addAll([SQLKeywords.limit, _limit.toString()]);
    }

    if (_offset != null) {
      builder.addAll([SQLKeywords.offset, _offset.toString()]);
    }

    return builder.join(SQLTypes.separator);
  }
}