abstract class Field<T> {

  String _name;
  /// Gets the name of the field
  String get name => _name;

  T _value;
  /// Gets the value
  T get value => _value;
  /// Sets the value
  set value(T value) {
    _value = value;
    markDirty();
  }

  bool _dirty = false;
  /// Gets whether the field was modified
  bool get dirty => _dirty;

  bool _primaryKey = false;
  /// Gets whether the field is a primary key
  bool get isPrimaryKey => _primaryKey;

  bool _autoIncrement = false;
  /// Gets whether the field is a auto increment field
  bool get isAutoIncrement => _autoIncrement;

  bool _notNull = false;
  /// Gets whether the field is marked as NOT NULL
  bool get isNotNull => _notNull;

  int _revision = 0;
  /// Gets the create fields revision
  int get revision => _revision;

  init(T v) {
    this.value = v;
  }

  Field(this._name, [this._value]);

  /* Extension Methods */
  /// Sets the initial revision
  void atRevision(int revision) {
    _revision = revision;
  }

  /// Marks the field value as dirty
  void markDirty() {
    _dirty = true;
  }

  /// Sets the field as primary key
  Field primaryKey() {
    _primaryKey = true;
    return this;
  }

  Field notNull() {
    _notNull = true;
    return this;
  }

  /// Sets the field as auto increment
  Field autoIncrement() {
    if (supportsAutoIncrement()) {
      _autoIncrement = true;
    } else {
      throw Exception("The field does not support auto increment");
    }
    return this;
  }

  /* Abstract methods */
  String toSqlCompatibleValue();
  void fromSqlCompatibleValue(String value);

  /* Abstract getters */
  bool supportsAutoIncrement();
  String get sqlType;
}