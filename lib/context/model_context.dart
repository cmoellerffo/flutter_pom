import 'package:flutter_pom/events/event_queue.dart';
import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/context/base_model_context.dart';
import 'package:flutter_pom/model/sql_types.dart';

class ModelContext<T extends Table> implements BaseModelContext<T> {
  Database _db;
  T _table;

  T get baseTable => _table;
  Database get handle => _db;

  final EventQueue<T> eventQueue = EventQueue<T>();

  T _model;
  /// Gets or sets the Model
  T get fields => _model;

  /// Creates a new model context instance
  ModelContext(Database db, T table) {
    _db = db;
    _table = table;
    _model = _table.getInstance();
  }


  @override
  Future<int> count([QueryBuilder q]) async {
    var select = _table.count();

    if (q != null) {
      select += SQLTypes.separator + q("");
    }

    var returnData = await _db.dbHandle.rawQuery(select);

    return returnData.first.values.first;
  }

  Future<List<T>> select([QueryBuilder q]) async {
    var list = <T>[];

    var select = _table.select(SQLKeywords.allSelector);

    if (q != null) {
      select += SQLTypes.separator + q("");
    }

    var returnData = await _db.dbHandle.rawQuery(select);

    for (var item in returnData) {
      var modelItem = _table.getInstance();
      list.add(Table.map(item, modelItem));
    }

    return list;
  }

  /// Returns an item by id
  Future<T> get(dynamic id) async {
    var temporaryEntity = _table.getInstance();
    temporaryEntity.idField.fromSqlCompatibleValue(id);

    var list = await select((q) {
        return q.where(_table.idField.equalsField(temporaryEntity.idField));
    });
    return list.first;
  }

  /// Updates the object
  Future<void> update(T obj) async {
    var updatedFields = obj.fields.where((f) => f.dirty && !f.isAutoIncrement);

    if (updatedFields.length > 0) {
      var fieldValues = updatedFields
          .map((f) => f.equalsField(f));

      var query = obj.update(fieldValues).where(obj.idField.equalsField(obj.idField));

      return await _db.dbHandle.execute(query);
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
        .map((f) => f.name).toList();

    var fieldValues = obj.fields
        .where((f) => !f.isAutoIncrement)
        .map((f) => f.toSqlCompatibleValue()).toList();

    var statement = obj.insert(fieldNames, fieldValues);

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
    var statement = _table.delete().where(_table.idField.equals(id.toString()));
    return await _db.dbHandle.execute(statement);
  }

  /// Deletes all data from the table
  Future<void> deleteAll() async {
    return await _db.dbHandle.execute(_table.delete());
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
    var builder = <String>[];
    builder.add(f.name);
    builder.add(f.sqlType);

    if (f.isPrimaryKey) {
      builder.add(SQLTypes.primaryKey);
    }
    if (f.isAutoIncrement) {
      builder.add(SQLTypes.autoIncrement);
    }
    if (f.isNotNull) {
      builder.add(SQLTypes.notNull);
    }

    return builder.join(SQLTypes.separator);
  }

  Future<bool> _exists(Table t) async {
    return false;
  }

  void _drop() async {
    await _db.dbHandle.execute(_table.drop());
  }


}
