import 'package:flutter_pom/events/event.dart';
import 'package:flutter_pom/model/table.dart';

abstract class EntityChangeEvent<T extends Table> extends Event<T> {

}