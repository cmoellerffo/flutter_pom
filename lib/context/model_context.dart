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

import 'dart:async';

import 'package:flutter_pom/builder/delete_builder.dart';
import 'package:flutter_pom/builder/query_count_builder.dart';
import 'package:flutter_pom/builder/query_distinct_builder.dart';
import 'package:flutter_pom/builder/update_builder.dart';
import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/context/base_model_context.dart';
import 'package:flutter_pom/model/sql_types.dart';

class ModelContext<T extends Table> implements BaseModelContext<T> {
  Database _db;
  T _table;

  T get baseTable => _table;

  /// Gets the underlying database handle
  Database get handle => _db;

  final StreamController<T> _addController = StreamController<T>.broadcast();

  /// Gets the stream for added items
  Stream<T> get onCreate => _addController.stream;

  final StreamController<T> _updateController = StreamController<T>.broadcast();

  /// Gets the stream for updated items
  Stream<T> get onUpdate => _updateController.stream;

  final StreamController _deleteController = StreamController.broadcast();

  /// Gets the stream for deleted items
  Stream<T> get onDelete => _deleteController.stream;

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
  Future<int> count([CountBuilder q]) async {
    var queryBuilder = QueryCountBuilder(_table);

    if (q != null) {
      queryBuilder = q(queryBuilder);
    }

    //PomLogger.instance.log.d(queryBuilder.toSql());
    var returnData = await _db.dbHandle.rawQuery(queryBuilder.toSql());
    //PomLogger.instance.log.d(returnData);

    return returnData.first.values.first;
  }

  /// Select an item from the database
  Future<List<T>> select([SelectBuilder q]) async {
    var list = <T>[];

    var querySelectBuilder = QuerySelectBuilder(_table);

    if (q != null) {
      querySelectBuilder = q(querySelectBuilder);
    }

    //PomLogger.instance.log.d(querySelectBuilder.toSql());
    var returnData = await _db.dbHandle.rawQuery(querySelectBuilder.toSql());
    //PomLogger.instance.log.d(returnData);

    for (var item in returnData) {
      var modelItem = _table.getInstance();
      list.add(Table.map(item, modelItem));
    }

    return list;
  }

  /// Select an distinct item from the database
  Future<List<dynamic>> distinct<Q extends Field>(Q field, [DistinctBuilder q]) async {
    var list = <dynamic>[];

    var querySelectBuilder = QueryDistinctBuilder(_table, field);

    if (q != null) {
      querySelectBuilder = q(querySelectBuilder);
    }

    //PomLogger.instance.log.d(querySelectBuilder.toSql());
    var returnData = await _db.dbHandle.rawQuery(querySelectBuilder.toSql());
    //PomLogger.instance.log.d(returnData);

    for (var item in returnData) {
      list.add(item.values.first);
    }

    return list;
  }


  /// Selects items from the table
  Future<Iterable<T>> where(bool test(T element)) async {
    var data = await this.select();
    var outData = List<T>();

    for (var item in data) {
      if (test(item)) {
        outData.add(item);
      }
    }
    return outData;
  }

  /// Returns an item by id
  Future<T> get(dynamic id) async {
    var temporaryEntity = _table.getInstance();
    temporaryEntity.idField.fromSqlCompatibleValue(id);

    var list = await select((q) {
      return q.where(_table.idField.equals(temporaryEntity.idField.value));
    });
    return list.first;
  }

  /// Updates the object
  Future<void> update(T obj) async {
    var updatedFields = obj.fields.where((f) => f.dirty && !f.isAutoIncrement);

    if (updatedFields.length > 0) {
      var fieldValues = updatedFields.map((f) => f.equals(f.value));

      var updateBuilder = UpdateBuilder(_table, fieldValues.toList())
          .where(obj.idField.equals(obj.idField.value));

      //PomLogger.instance.log.d(updateBuilder.toSql());

      await _db.dbHandle.execute(updateBuilder.toSql());

      _updateController.add(obj);

      return;
    }
    return;
  }

  /// Updates a range of items
  Future<void> updateRange(List<T> objList) async {
    return objList.forEach((f) async => await update(f));
  }

  /// Puts an item
  Future<void> put(T obj) async {
    var fieldNames =
        obj.fields.where((f) => !f.isAutoIncrement).map((f) => f.name).toList();

    var fieldValues = obj.fields
        .where((f) => !f.isAutoIncrement)
        .map((f) => f.toSqlCompatibleValue())
        .toList();

    var statement = obj.insert(fieldNames, fieldValues);

    //PomLogger.instance.log.d(statement);
    await _db.dbHandle.execute(statement);

    var rowId = await _db.dbHandle.rawQuery("SELECT last_insert_rowid()");

    if (obj.idField.sqlType == SQLTypes.integer) {
      obj.idField.value = rowId.first.values.first;
    } else {
      // We do not reparse the id as it may be a string or something else
    }

    _addController.add(obj);

    return;
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
    var deleteBuilder =
        DeleteBuilder(_table).where(_table.idField.equals(id));
    //PomLogger.instance.log.d(deleteBuilder.toSql());
    await _db.dbHandle.execute(deleteBuilder.toSql());
    _deleteController.add(id);
    return;
  }

  /// Deletes all data from the table
  Future<void> deleteAll() async {
    var builderSql = DeleteBuilder(_table).toSql();
    //PomLogger.instance.log.d(builderSql);
    await _db.dbHandle.execute(builderSql);
    _deleteController.add("all");
    return;
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

      // create indexes for all fields that require indexes
      for (var field in _table.fields.where((f) => f.idxCreate)) {
        await _createIdx(field);
      }

      await _db.dbHandle.execute(createStatement);
    }
  }

  Future<void> _createIdx(Field field) async {
    if (field.idxCreate) {
      var uniqueKey = (field.idxUnique) ? "UNIQUE" : "";
      var createIdxStatement = "CREATE $uniqueKey INDEX idx_${_table.tableName}_${field.name} ON ${_table.tableName}(${field.name})";

      await _db.dbHandle.execute(createIdxStatement);
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
