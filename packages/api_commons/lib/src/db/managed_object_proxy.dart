import 'dart:mirrors';

import 'package:conduit_core/conduit_core.dart';

abstract class ManagedObjectProxy<T> extends ManagedObject<T> {
  @override
  void readFromMap(Map<String, dynamic> object) {
    final mirror = reflect(this);
    object.forEach((key, v) {
      final property = entity.properties[key];
      if (property == null) {
        throw ValidationException(['invalid input key "$key"']);
      }
      if (property.isPrivate) {
        throw ValidationException(['invalid input key "$key"']);
      }

      if (property is ManagedAttributeDescription) {
        if (!property.isTransient) {
          backing.setValueForProperty(
              property, property.convertFromPrimitiveValue(v));
        } else {
          if (!property.transientStatus!.isAvailableAsInput) {
            // throw ValidationException(['invalid input key "$key"']);
          }

          final decodedValue = property.convertFromPrimitiveValue(v);

          if (!property.isAssignableWith(decodedValue)) {
            // throw ValidationException(['invalid input type for key "$key"']);
          }

          mirror.setField(Symbol(key), decodedValue);
        }
      } else {
        backing.setValueForProperty(
            property, property.convertFromPrimitiveValue(v));
      }
    });
  }
}
