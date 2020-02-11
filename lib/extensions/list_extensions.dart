import 'package:flutter_pom/context/base_model_context.dart';
import 'package:flutter_pom/flutter_pom.dart';
import 'package:flutter_pom/model/fields/key_field.dart';

extension ListExtensions<T extends Table> on List<T> {
  Future<List<T>> include<F extends Table>(Database db, KeyField<F> field) async {
    BaseModelContext<F> context = await db.of<F>();
    var outputList = List<T>();

    for (Table item in this) {
      KeyField keyField =
          item.fields.firstWhere((f) => f.name == field.name, orElse: null);
      if (keyField == null) {
        throw new AssertionError(
            "There is no field '${field.name}' defined in Table");
      } else if (keyField.itemKey != null && keyField.itemKey >= 0){
        keyField.binding = await context.get(keyField.itemKey);
      }
      outputList.add(item);
    }
    return outputList;
  }
}
