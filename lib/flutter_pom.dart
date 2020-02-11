/*
BSD 2-Clause License

Copyright (c) 2020, VIVASECUR GmbH
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

library flutter_pom;

export 'model/table.dart';
export 'model/field.dart';
export 'model/database.dart';
export 'model/serializable.dart';

// Fields

export 'model/fields/integer_field.dart';
export 'model/fields/id_field.dart';
export 'model/fields/string_field.dart';
export 'model/fields/double_field.dart';
export 'model/fields/datetime_field.dart';
export 'model/fields/bool_field.dart';
export 'model/fields/secure_string_field.dart';
export 'model/fields/object_field.dart';
export 'model/fields/key_field.dart';

// Errors

export 'errors/field_constraint_error.dart';
export 'errors/missing_primary_key_error.dart';
export 'errors/multiple_primary_key_error.dart';
export 'errors/table_configuration_error.dart';
export 'errors/missing_field_error.dart';
export 'errors/duplicate_field_error.dart';

// Helpers

export 'model/sql_types.dart';
export 'extensions/list_extensions.dart';

// Query Builder

export 'builder/query_select_builder.dart';
export 'builder/selectors/sql_condition.dart';
export 'builder/selectors/sql_selector.dart';
export 'builder/selectors/sql_where_selector.dart';
export 'builder/delete_builder.dart';
export 'builder/query_count_builder.dart';
