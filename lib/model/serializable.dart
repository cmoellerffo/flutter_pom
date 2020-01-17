abstract class Serializable {
  Map<String, String> toJson();
  void fromJson(String value);
}