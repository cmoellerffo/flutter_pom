import 'package:flutter_pom/events/event_queue.dart';
import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/context/base_model_context.dart';

class ModelContext<T extends Table> implements BaseModelContext<T> {
  Database _db;
  T _table;

  T get baseTable => _table;
  Database get handle => _db;

  final EventQueue<T> eventQueue = EventQueue<T>();

  /// Creates a new model context instance
  ModelContext(Database db, T table) {
    _db = db;
    _table = table;
  }

  /// Returns items by range
  Future<List<T>> getRange({String where = "", String orderBy = ""}) async {
    var _list = List<T>();
    var query = "SELECT * FROM ${_table.tableName}";

    if (where.isNotEmpty) {
      query += " WHERE($where)";
    }
    if (orderBy.isNotEmpty) {
      query += " ORDER BY $orderBy";
    }

    var returnData = await _db.dbHandle.rawQuery(query);

    for (var item in returnData) {
      var modelItem = _table.getInstance();
      _list.add(Table.map(item, modelItem));
    }

    return _list;
  }

  /// Returns an item by id
  Future<T> get(dynamic id) async {
    var temporaryEntity = _table.getInstance();
    temporaryEntity.idField.fromSqlCompatibleValue(id);

    var list = await getRange(where: "${_table.idField.name} = ${temporaryEntity.idField.toSqlCompatibleValue()}");
    return list.first;
  }

  /// Updates the object
  Future<void> update(T obj) async {
    var updatedFields = obj.fields.where((f) => f.dirty && !f.isAutoIncrement);

    if (updatedFields.length > 0) {
      var fieldValues = updatedFields
          .map((f) => "${f.name} = ${f.toSqlCompatibleValue()}")
          .join(",");
      var statement =
          "UPDATE ${obj.tableName} SET $fieldValues WHERE ${obj.idField.name} = ${obj.idField.toSqlCompatibleValue()}";

      return await _db.dbHandle.execute(statement);
    }
    return;
  }

  /// Updates a range of items
  Future<void> updateRange(List<T> objList) async {
    return objList.forEach((f) async => await update(f));
  }

  /// Puts an item
  Future<void> put(T obj) async {
    var fieldNames = obj.fields
        .where((f) => !f.isAutoIncrement)
        .map((f) => f.name)
        .join(',');
    var fieldValues = obj.fields
        .where((f) => !f.isAutoIncrement)
        .map((f) => f.toSqlCompatibleValue())
        .join(',');
    var statement =
        "INSERT INTO ${obj.tableName} ($fieldNames) VALUES($fieldValues)";

    return await _db.dbHandle.execute(statement);
  }

  /// Puts all items
  Future<void> putRange(List<T> obj) async {
    return obj.forEach((f) async => await put(f));
  }

  /// Deletes an item by obj
  Future<void> delete(T obj) async {
    return await deleteById(obj.idField.value);
  }

  /// Deletes a range of items
  Future<void> deleteRange(List<T> objList) async {
    return objList.forEach((f) async => await delete(f));
  }

  /// Deletes an item by id
  Future<void> deleteById(int id) async {
    var statement =
        "DELETE FROM ${_table.tableName} WHERE ${_table.idField.name} = $id";
    return await _db.dbHandle.execute(statement);
  }

  /// Deletes all data from the table
  Future<void> deleteAll() async {
    return await _db.dbHandle.execute("DELETE FROM ${_table.tableName}");
  }

  /** Non interface methods **/

  /// creates the table
  Future<void> create([bool drop = false]) async {
    var tableExists = await _exists(_table);
    if (tableExists && drop) {
      _drop();
    } else if (!tableExists) {
      var fieldDefinitions =
          _table.fields.map((f) => buildCreateFieldStatement(f));
      var createStatement =
          "CREATE TABLE IF NOT EXISTS ${_table.tableName} (${fieldDefinitions.join(',')})";
      await _db.dbHandle.execute(createStatement);
    }
  }

  static String buildCreateFieldStatement(Field f) {
    var createStatement = "${f.name} ${f.sqlType}";

    if (f.isPrimaryKey) {
      createStatement += " PRIMARY KEY";
    }
    if (f.isAutoIncrement) {
      createStatement += " AUTOINCREMENT";
    }
    if (f.isNotNull) {
      createStatement += " NOT NULL";
    }

    return createStatement;
  }

  Future<bool> _exists(Table t) async {
    return false;
  }

  void _drop() async {
    await _db.dbHandle.execute("DROP TABLE IF EXISTS ${_table.tableName}");
  }
}
