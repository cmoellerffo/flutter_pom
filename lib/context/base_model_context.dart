import 'package:flutter_pom/flutter_pom.dart';

typedef String QueryBuilder(String baseQuery);

/// Abstract class
abstract class BaseModelContext<T extends Table> {

  T get fields;

  Future<T> get(dynamic id);
  Future<void> update(T obj);
  Future<void> updateRange(List<T> objList);
  Future<void> put(T obj);
  Future<void> putRange(List<T> obj);
  Future<void> delete(T obj);
  Future<void> deleteRange(List<T> objList);
  Future<void> deleteById(int id);
  Future<void> deleteAll();

  Future<List<T>> select([QueryBuilder callback]);
  Future<int> count([QueryBuilder callback]);
}
