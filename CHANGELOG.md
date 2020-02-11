## [0.1.24+1] - 11.02.2020

* Moved repository to GitHub

## [0.1.24] - 10.02.2020

* Removed logging for now. It will be available again in the next release in a configurable form
* Fixed a bug that lead to error-messages while querying 'last_row_id()' for non-Integer key fields

## [0.1.23+1] - 30.01.2020

* Added new Section do Documentation showing the usage of the KeyField

## [0.1.23] - 30.01.2020

* You can now reference other tables inside a table using the KeyField field

## [0.1.22] - 29.01.2020

* Fixed critical bug in 'delete' builder that prevented creating a valid query

## [0.1.21] - 28.01.2020

* Fixed migration related bugs

## [0.1.20] - 28.01.2020

* Fixed migration related bugs

## [0.1.19] - 27.01.2020

* Added 'distinct' method for querying single field values distinct

## [0.1.18+4] - 27.01.2020

* Fixed value assignment bug on query deserialization

## [0.1.18+3] - 27.01.2020

* Fixed value assignment bug in SecureString field 

## [0.1.18+2] - 27.01.2020

* Fixed String comparison of SecureString field

## [0.1.18+1] - 27.01.2020

* Moved FieldExtensions to Field Class

## [0.1.18] - 27.01.2020

* Added Logging Framework for better insights on whats going on

## [0.1.17] - 27.01.2020

* Added 'enableMigrations: bool' to Database. This enables automatic migration in case of new fields
* In your table you can now override the method 'Future<void> migrate(MigrationContext context, int fromRevision, int toRevision) async' to do some internal migration stuff
* Fixed bug in 'update' QueryBuilder
* Fixed bug in 'delete' QueryBuilder

## [0.1.16+3] - 24.01.2020

* Removed 'event' section from library. This is a cosmetic thing as it was not used in production until not

## [0.1.16+2] - 24.01.2020

* Dart-Formatting aligned

## [0.1.16+1] - 24.01.2020

* Fixed UpdateBuilder to include SET statements properly
* Did some more refactoring and formatting

## [0.1.16] - 24.01.2020

* Added Streams for 'onCreate', 'onDelete' and 'onUpdate'

## [0.1.15+1] - 23.01.2020

* Removed unnecessary dependencies in pubspec.

## [0.1.15] - 23.01.2020

* Introduced 'where' method to do dart-side filtering of cached data

## [0.1.14+2] - 23.01.2020

* You can now access the fields inside QueryBuilder by '.fields' Property

## [0.1.14+1] - 23.01.2020

* Extended Exports for fields 

## [0.1.14] - 23.01.2020

* Added QueryBuilder Framework to make query building more reliable

## [0.1.13] - 23.01.2020

* Removed unused dart:convert import
* Adapted Sample to meet current API

## [0.1.12] - 23.01.2020

* Removed getRange for 'select()' and 'count()' methods that use QueryBuilder as arguments

## [0.1.11] - 23.01.2020

* Added NULL conversion fix for String Fields
* SQL Creation is now more generic
* Changed some underlying Field implementations
* Added SQLHelper for generating Decision Trees

## [0.1.10] - 23.01.2020

* Added constraint to prevent infinite or negativeInfinite values on double fields.

## [0.1.9] - 23.01.2020

* Fixed bug in context creation
* Fixed bug with nullable Datetime objects

## [0.1.8] - 22.01.2020

* Changed method parameter signature of get() to use 'dynamic' instead of fields
* Mapping of id Field in 'get' now works internally

## [0.1.7] - 22.01.2020

* Changed method parameter signature of get() to use Fields instead of ids.

## [0.1.6] - 17.01.2020

* Removed migrations for now

## [0.1.5] - 17.01.2020

* Bugfix release

## [0.1.4] - 17.01.2020

* Bugfix release

## [0.1.3] - 17.01.2020

* Bugfix release

## [0.1.2] - 17.01.2020

* Bugfix release

## [0.1.1] - 17.01.2020

* Bugfix release

## [0.1.0] - 17.01.2020

* Added automatic migrations and overridable migrations

## [0.0.9] - 16.01.2020

* Fixed update statement to include primary keys and disable auto-increment fields

## [0.0.8] - 16.01.2020

* Added more reliability and flexibility for value to field mapping of various types
* Implemented more unit tests for better coverage

## [0.0.7] - 16.01.2020

* Removed unnecessary constraints disabling primary-keys for several fields
* Changed parameter signature of "fromSql" to dynamic

## [0.0.6] - 16.01.2020

* Added specific errors
* Added Unit-Testing
* Fixed bugs with handling notNull constraints
* Fixed bugs with handling autoIncrement constraints
* Fixed bugs with handling mapping errors

## [0.0.5] - 16.01.2020

* The export for SecureString was missing

## [0.0.4] - 16.01.2020

* Added SecureStringField to provide a hashed database field for storing passwords etc.
* Changed field signature of StringField from VARCHAR(255) to TEXT

## [0.0.3] - 16.01.2020

* New MIT License agreement was added to the root package
* Fixed install instructions to make use of pub.dev instead of using a local path 
* Changed Homepage to a secure URI

## [0.0.2] - 16.01.2020

* Started satisfying all required publishing specs

## [0.0.1] - 16.01.2020

* Initial Release
