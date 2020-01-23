import 'package:flutter_pom/builder/selectors/sql_condition.dart';
import 'package:flutter_pom/builder/selectors/sql_selector.dart';
import 'package:flutter_pom/flutter_pom.dart';

class SQLWhereSelector extends SQLSelector {

  SQLCondition condition;

  SQLWhereSelector(this.condition);

  String toSql() {
    var builder = <String>[];
    builder.addAll([
      SQLKeywords.where,
      condition.toSql()
    ]);
    return builder.join(SQLTypes.separator);
  }

}