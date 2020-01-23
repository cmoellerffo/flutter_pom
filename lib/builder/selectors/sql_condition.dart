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

    builder.addAll([
      operatorValue,
      field.name,
      comparatorValue,
      field.toSql(value)
    ]);

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

extension SQLConditionExtension on Field {
  SQLCondition compare(dynamic value, SQLComparators comparator) {
    return SQLCondition(this, comparator, value);
  }

  SQLCondition compareField(Field field, SQLComparators comparator) {
    return compare(field.toSqlCompatibleValue(), comparator);
  }

  SQLCondition equals(dynamic value) {
    return compare(value, SQLComparators.Equals);
  }

  SQLCondition equalsField(Field value) {
    return compare(value.toSqlCompatibleValue(), SQLComparators.Equals);
  }

  SQLCondition notEquals(dynamic value) {
    return compare(value, SQLComparators.NotEquals);
  }

  SQLCondition notEqualsField(Field field) {
    return compare(field.toSqlCompatibleValue(), SQLComparators.NotEquals);
  }

  SQLCondition gt(dynamic value) {
    return compare(value, SQLComparators.Greater);
  }

  SQLCondition gte(dynamic value) {
    return compare(value, SQLComparators.GreaterOrEqual);
  }

  SQLCondition lt(dynamic value) {
    return compare(value, SQLComparators.Lower);
  }

  SQLCondition lte(dynamic value) {
    return compare(value, SQLComparators.LowerOrEqual);
  }
}

enum SQLLogicOperator {
  none,
  and,
  or
}