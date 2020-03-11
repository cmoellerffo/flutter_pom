# flutter_pom

Flutter Persistent Object Mapper based on sqflite provides model based SQLite access including automatic database creation

## Installing

### Add dependency

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_pom: ^0.0.3
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
    // This method has to be called once before 
    // accessing the database
    await db.open();
    
    // Get the automatically created context of the 
    // table 'SampleTable'
    var context = await db.of<SampleTable>();
    
    // Create a new SampleTable item (think of it as a row)
    var sampleItem = SampleTable();
    
    // Access the str field
    sampleItem.str.value = "String value";
    
    // Put the item into the database
    await context.put(sampleItem);
    
    // Get all items 
    var itemsFilter = await context.select();
    
    // A complex filter scenario with comparison of 
    // field values and ordering
    // We also support limiting and offsets
    var itemsFilter2 = await c.select((q) {
          return q
                 .where(c.fields.idField.gte(3))
                 .and(c.fields.idField.lte(20))
                 .orderByAsc([c.fields.idField])
                 .limit(40)
                 .offset(2);
        });    
    
    // NOTICE: There is an alternative way of querying 
    // data using Dart included test methods.
    // The downside of this approach is that all data will 
    // be queried and cached before the
    // filtering begins. 
    // For datasets > 1k items you should use the 'select' 
    // method to do filtering on db level
    // instead.
    //
    // The following query filters the exact same data 
    // like 'itemsFilter2' without ordering 
    // and limiting. This can later be done with dart language 
    
    var itemsFilter3 = await c.where((i) => 
                                i.idField.value >= 3 &&
                                i.idField.value <= 20);
    
    // Count all items
    var count1 = await c.count();
    
    // Count all items where id >= 3 and id <= 20
    var count2 = await c.count((q) {
           return q
                  .where(c.fields.idField.gte(3))
                  .and(c.fields.idField.lte(20));
        });
    
    // Delete the item
    await context.delete(sampleItem);
    
    // Update the item. Only changed values will be updated.
    await context.update(sampleItem);
    
    // Register for the onCreate Stream that gets fired 
    // everytime somebody adds an item
    context.onCreate.listen((sampleItem) {
      // do something with the item
    });
}
```

### Relating Tables 
Starting with version 0.1.23 you can now bind tables to a field. This gives you the chance
to create dependent tables you can query with a new list extension.

For now only 1:1 relations are supported.

The following code will give you an example of how to get started:
```dart
class User extends Table {
  /// We only show things that changed here. 
  /// The Table implementation is still the same 
  /// as described prior.
  StringField userName = StringField("user_name").notNull();
 
  /// Here we reference the job table. 
  /// The framework will internally save the id of the
  /// referenced table item only
  KeyField<Job> job = KeyField<Job>("job_id");
}

/// You may want to manage existing jobs in a seperate table
class Job extends Table {
  /// Same as above
  StringField jobName = StringField("job_name").notNull();
}


/// Example Method adding a new user with a *new* job
void addUser(User user, Job job) async {
  var users = await db.of<User>();  
  var jobs = await db.of<Job>();
  
  user.job.binding = job;
  
  await jobs.put(job);
  await users.put(user);
}

/// Example method reading all users and resolving 
/// all job items automatically
void getUsers() async {
  var users = await db.of<User>();
  var jobs = await db.of<Job>();
  
  /// Here we select all users and then call the method
  /// 'include' on the resulting list.
  /// 'include' expects the database context and the field
  /// you want to resolve.
  var userList = users.select().include<Job>(db, User().job);
}
```

### Indexing fields

You can easily let POM create indexes for your fields by adding .withIndex()
to the field definition:

````dart
StringField email = StringField("email").withIndex(unique: true);
````

You can also define whether the indexed values shall be unique or not.

### Transaction Support (since 0.1.26)

You can easily manage your transactions by using the 'transaction()' method
of your database and provide it to all supported methods inside your context.

Example:
````dart
var txn = db.transaction();

await db.of<User>().add(newUser, txn);
await db.of<User>().deleteById(5, txn);

await txn.commit();
````