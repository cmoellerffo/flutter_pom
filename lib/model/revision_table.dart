import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/model/field.dart';

/// Revision Safe Table provides an easy and robust way to store and modify
/// Your data revision safe.
/// All your update and delete operations will lead to a modified entry
/// without actually editing your old entity
abstract class RevisionTable extends Table {
  RevisionTable(String tableName) : super(tableName);

  @override
  Table getInstance();

  @override
  List<Field> initializeFields();

  @override
  int get revision;

  /// Gets whether the current value is the Head
  BoolField isHead = BoolField("_head");

  /// Gets the current entity revision
  IntegerField dataRevision = IntegerField("_revision");

  /// Gets the next valid revision, we need this in order to see when
  /// the revision tree is broken due to manual deletion of rows
  IntegerField nextRevision = IntegerField("_next")
                              ..notNull(-1);
}