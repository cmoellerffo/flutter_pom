import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/model/fields/id_field.dart';
import 'package:flutter_pom/model/fields/integer_field.dart';
import 'package:flutter_pom/model/fields/datetime_field.dart';

class SampleTable2 extends Table {
  SampleTable2() : super("sample_table2");

  /// Gets or sets the id
  final IdField id = IdField("id").autoIncrement();

  /// Gets or sets the key
  final IntegerField counterValue = IntegerField("counterValue");

  /// Gets or sets the value
  final DateTimeField dateTime = DateTimeField("dateTime");

  final IntegerField staticValue = IntegerField("static")
    ..atRevision(2);

  @override
  Table getInstance() {
    return SampleTable2();
  }

  @override
  List<Field> initializeFields() {
    return [
      id,
      counterValue,
      dateTime,
      staticValue
    ];
  }

  /// This is just a helper for creating this thing externally
  static SampleTable2 build(int counterValue, DateTime dateTime) {
    var item = SampleTable2();
    item.counterValue.value = counterValue;
    item.dateTime.value = dateTime;
    return item;
  }

  @override
  int get revision => 2;

}