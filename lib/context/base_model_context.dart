import 'package:flutter_pom/flutter_pom.dart';

/// Abstract class
abstract class BaseModelContext<T extends Table> {
  Future<T> get(dynamic id);
  Future<List<T>> getRange({String where = "", String orderBy = ""});
  Future<void> update(T obj);
  Future<void> updateRange(List<T> objList);
  Future<void> put(T obj);
  Future<void> putRange(List<T> obj);
  Future<void> delete(T obj);
  Future<void> deleteRange(List<T> objList);
  Future<void> deleteById(int id);
  Future<void> deleteAll();
}
