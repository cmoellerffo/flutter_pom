import 'package:flutter_pom/builder/query_count_builder.dart';
import 'package:flutter_pom/flutter_pom.dart';

typedef QuerySelectBuilder SelectBuilder(QuerySelectBuilder builder);
typedef QueryCountBuilder CountBuilder(QueryCountBuilder builder);

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

  Future<Iterable<T>> where(bool test(T element));

  Future<List<T>> select([SelectBuilder callback]);
  Future<int> count([CountBuilder callback]);
}
