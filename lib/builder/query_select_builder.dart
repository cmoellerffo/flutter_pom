import 'package:flutter_pom/builder/selectors/sql_condition.dart';
import 'package:flutter_pom/builder/selectors/sql_where_selector.dart';
import 'package:flutter_pom/model/field.dart';
import 'package:flutter_pom/model/sql_types.dart';
import 'package:flutter_pom/model/table.dart';

class QuerySelectBuilder {

  SQLWhereSelector _whereSelector;
  List<Field> _orderBy;
  SQLSortOrder _sortOrder;
  Table _table;
  int _limit;
  int _offset;

  QuerySelectBuilder(this._table);

  QuerySelectBuilder where(SQLCondition condition) {
    if (_whereSelector != null) throw UnsupportedError("There is already a 'where' clause defined");

    _whereSelector = SQLWhereSelector(condition);
    return this;
  }

  QuerySelectBuilder orderBy(SQLSortOrder order, List<Field> field) {
    if (_orderBy != null) throw UnsupportedError("There is already a 'orderBy' clause defined");
    _orderBy = field;
    _sortOrder = order;
    return this;
  }

  QuerySelectBuilder orderByAsc(List<Field> fields) {
    orderBy(SQLSortOrder.Ascending, fields);
    return this;
  }

  QuerySelectBuilder orderByDesc(List<Field> fields) {
    orderBy(SQLSortOrder.Descending, fields);
    return this;
  }

  QuerySelectBuilder limit(int max) {
    if (_limit != null) throw UnsupportedError("There is already a 'limit' clause defined");
    _limit = max;
    return this;
  }


  QuerySelectBuilder offset(int start) {
    if (_offset != null) throw UnsupportedError("There is already a 'offsert' clause defined");
    _offset = start;
    return this;
  }

  String toSql() {
    var builder = <String>[];
    builder.addAll(
        [SQLKeywords.select, SQLKeywords.allSelector, SQLKeywords.from, _table.tableName]);

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
        builder.addAll(
            [SQLKeywords.orderBy, _orderBy.map((f) => f.name).join(SQLTypes.comma), sortOrder]);
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