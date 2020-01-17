import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/model/fields/id_field.dart';
import 'package:flutter_pom/model/fields/integer_field.dart';
import 'package:flutter_pom/model/fields/datetime_field.dart';

class SampleTable extends Table {
  SampleTable() : super("sample_table");

  /// Gets or sets the id
  final IdField id = IdField("id").autoIncrement();

  /// Gets or sets the key
  final IntegerField counterValue = IntegerField("counterValue");

  /// Gets or sets the value
  final DateTimeField dateTime = DateTimeField("dateTime");

  @override
  Table getInstance() {
    return SampleTable();
  }

  @override
  List<Field> initializeFields() {
    return [
      id,
      counterValue,
      dateTime
    ];
  }

  /// This is just a helper for creating this thing externally
  static SampleTable build(int counterValue, DateTime dateTime) {
    var item = SampleTable();
    item.counterValue.value = counterValue;
    item.dateTime.value = dateTime;
    return item;
  }

  @override
  int get revision => 1;

}