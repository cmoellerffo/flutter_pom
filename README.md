# flutter_pom

A flutter persistent object mapper library

## Installing

### Add dependency

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_pom:
    path: path/to/flutter_pom/
```

### Install the plugin

Now you can install the package (if you got it from pub.dev) via console.

```
$ flutter pub get
```

### Import the plugin

Finally you have to import the plugin into your Dart source

```dart
import 'package:flutter_pom/flutter_pom.dart';
```

## Example

To kickstart with the newly installed library you will have to create the necessary model and database classes.

### Create the Table-model

The table model represents the configuration of your table. This includes all columns and the table name.
In order to work this needs to extend from Table (flutter_pom).

```dart
class SampleTable extends Table {
  
  // These are the fields that we define for the table.
  // Each field corresponds to a table column
  
  final IdField id = IdField("id").autoIncrement();
  final StringField str = StringField("str");
  
  // You have to override the method 'getInstance' for the
  // deserializer to get a new instance of your type as dart
  // does not support reflection well by now.
  
  @override
  Table getInstance() {
    return SampleTable();
  }
  
  // initializeFields provides the TableBuilder in the background
  // with all defined fields. As dart does not support reflection 
  // this is our way to go.
  
  @override
  List<Field> initializeFields() {
    return [
      id,
      str
    ];
  }
}
``` 

### Create the Database model

... tbd