import 'package:flutter_pom/builder/selectors/sql_condition.dart';
import 'package:flutter_pom/builder/selectors/sql_where_selector.dart';
import 'package:flutter_pom/model/sql_types.dart';
import 'package:flutter_pom/model/table.dart';

class QueryCountBuilder {

  SQLWhereSelector _whereSelector;
  Table _table;

  QueryCountBuilder(this._table);

  QueryCountBuilder where(SQLCondition condition) {
    if (_whereSelector != null) throw UnsupportedError("There is already a 'where' clause defined");

    _whereSelector = SQLWhereSelector(condition);
    return this;
  }


  String toSql() {
    var builder = <String>[];
    builder.addAll(
        [SQLKeywords.select, SQLKeywords.count, SQLKeywords.allSelector.inBrackets(), SQLKeywords.from, _table.tableName]);

    if (_whereSelector != null) {
      builder.add(_whereSelector.toSql());
    }

    return builder.join(SQLTypes.separator);
  }
}