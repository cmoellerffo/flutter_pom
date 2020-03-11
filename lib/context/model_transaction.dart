import 'package:flutter_pom/context/base_model_transaction.dart';
import 'package:flutter_pom/flutter_pom.dart';

class ModelTransaction implements BaseModelTransaction {

  final Database _db;
  final List<String> _transactionQueries = <String>[];

  ModelTransaction(this._db);

  void add(String query) {
    _transactionQueries.add(query);
  }

  @override
  Future<void> execute() async {
    await _db.dbHandle.transaction((tx) async {
      var batch = tx.batch();
      for (var q in _transactionQueries) {
        batch.execute(q);
      }
      await batch.commit();
    });
  }

}