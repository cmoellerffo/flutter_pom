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
