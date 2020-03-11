abstract class BaseModelTransaction {
  void add(String q);
  Future<void> execute();
}