## Example

To kickstart with the newly installed library you will have to create the necessary model and database classes.

### Create the Table-model

The table model represents the configuration of your table. This includes all columns and the table name.
In order to work this needs to extend from Table (flutter_pom).

```dart
class SampleTable extends Table {
  // The constructor has to call 'super' with the name of the table
  SampleTable() : super("sample_table");
  
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

Next you have to create a database model. The model needs to be inherited from Database (flutter_pom).
The database model contains all tables that you want to access inside the specified database.

Note: There can be more than one database model inside your app

```dart
class SampleDb extends Database {
  // The constructor has to call 'super' with the database name
  SampleDb() : super("sample.db");
  
  // initializeDatabase provides the DatabaseBuilder in the background
  // with all containing databases. As dart does not support reflection
  // this is our way to go.
  
  @override
  Map<Type, Table> initializeDatabase() {
    return <Type, Table>{
      SampleTable: SampleTable()
    };
  }
}
```

### Use the database in your App Logic

Now its time to make use of the newly created database and tables.

```dart
void Do() async {
  
    // initialize the database
    var db = SampleDb();
    
    // open() the connection to the database. 
    // This method has to be called once before accessing the database
    await db.open();
    
    // Get the automatically created context of the table 'SampleTable'
    var context = db.of<SampleTable>();
    
    // Create a new SampleTable item (think of it as a row)
    var sampleItem = SampleTable();
    
    // Access the str field
    sampleItem.str.value = "String value";
    
    // Put the item into the database
    await context.put(sampleItem);
    
    // Get all items from the table
    // If you do not provide any arguments to 'getRange()' it will return
    // all items from the selected table context
    var items = await context.getRange();
    
    // Get all items with filter
    var itemsFilter = await context.getRange(where: "str = 'String value'");
    
    // Order the items 
    var itemsOrder = await context.getRange(orderBy: 'str DESC');
    
    // Delete the item
    await context.delete(sampleItem);
    
    // Update the item. Only changed values will be updated.
    await context.update(sampleItem);
}
```