import 'package:flutter_pom/model/table.dart';

class SQLTypes {
  static final String text = "TEXT";
  static final String double = "DOUBLE";
  static final String integer = "INTEGER";
  static final String boolean = integer;
  static final String dateTime = "DATETIME";

  static final String primaryKey = "PRIMARY KEY";
  static final String autoIncrement = "AUTOINCREMENT";

  static final String nullValue = "NULL";
  static final String notNull = "NOT $nullValue";

  static final String stringIdentifier = "'";
  static final String separator = " ";

  static final String eq = "=";
  static final String like = "LIKE";
  static final String not = "!";
  static final String gt = ">";
  static final String lt = "<";
  static final String wildcard = "%";
  static final String comma = ",";
  static final String bracketOpen = "(";
  static final String bracketClose = ")";

  static String toSqlString(String value) {
    if (value == null) {
      return nullValue;
    } else {
      return "$stringIdentifier$value$stringIdentifier";
    }
  }
}

class SQLKeywords {
  static final String select = "SELECT";
  static final String insert = "INSERT INTO";
  static final String from = "FROM";
  static final String or = "OR";
  static final String and = "AND";
  static final String allSelector = "*";
  static final String drop = "DROP";
  static final String table = "TABLE";
  static final String where = "WHERE";
  static final String ascending = "ASC";
  static final String descending = "DESC";
  static final String orderBy = "ORDER${SQLTypes.separator}BY";
  static final String update = "UPDATE";
  static final String set = "SET";
  static final String delete = "DELETE";
  static final String values = "VALUES";
  static final String count = "COUNT";
  static final String limit = "LIMIT";
  static final String offset = "OFFSET";
  static final String dropTable =
      "DROP${SQLTypes.separator}${SQLKeywords.table}${SQLTypes.separator}IF${SQLTypes.separator}NOT${SQLTypes.separator}EXISTS";
}

extension TableHelper on Table {
  String insert(List<String> fields, List<String> values) {
    var builder = <String>[];
    builder.addAll([
      SQLKeywords.insert,
      this.tableName,
      fields.join(SQLTypes.comma).inBrackets(),
      SQLKeywords.values,
      values.join(SQLTypes.comma).inBrackets()
    ]);
    return builder.join(SQLTypes.separator);
  }

  String drop() {
    return SQLKeywords.dropTable + SQLTypes.separator + this.tableName;
  }
}

extension SQLHelper on String {
  String inBrackets() {
    return SQLTypes.bracketOpen + this + SQLTypes.bracketClose;
  }
}

enum SQLSortOrder { Ascending, Descending }

enum SQLComparators {
  Equals,
  Greater,
  Lower,
  Like,
  GreaterOrEqual,
  LowerOrEqual,
  NotEquals
}
