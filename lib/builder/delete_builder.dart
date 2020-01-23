import 'package:flutter_pom/builder/selectors/sql_condition.dart';
import 'package:flutter_pom/builder/selectors/sql_where_selector.dart';
import 'package:flutter_pom/model/sql_types.dart';
import 'package:flutter_pom/model/table.dart';

class DeleteBuilder {
  SQLWhereSelector _whereSelector;
  Table _table;

  DeleteBuilder(this._table);

  DeleteBuilder where(SQLCondition condition) {
    if (_whereSelector != null) throw UnsupportedError("There is already a 'where' clause defined");
    _whereSelector = SQLWhereSelector(condition);
    return this;
  }


  String toSql() {
    var builder = <String>[];
    builder.addAll(
        [SQLKeywords.delete, _table.tableName, ]);

    if (_whereSelector != null) {
      builder.add(_whereSelector.toSql());
    }

    return builder.join(SQLTypes.separator);
  }
}