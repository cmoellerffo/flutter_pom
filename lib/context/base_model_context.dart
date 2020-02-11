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

import 'package:flutter_pom/builder/query_count_builder.dart';
import 'package:flutter_pom/builder/query_distinct_builder.dart';
import 'package:flutter_pom/flutter_pom.dart';

typedef QuerySelectBuilder SelectBuilder(QuerySelectBuilder builder);
typedef QueryCountBuilder CountBuilder(QueryCountBuilder builder);
typedef QueryDistinctBuilder DistinctBuilder(QueryDistinctBuilder builder);

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
  Future<List<dynamic>> distinct<Q extends Field>(Q f,[DistinctBuilder callback]);

  Stream<T> get onUpdate;
  Stream<T> get onDelete;
  Stream<T> get onCreate;
}
