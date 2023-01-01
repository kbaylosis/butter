bool isManagedEntity(dynamic object, {bool includeSet = false}) {
  var managed = false;
  try {
    managed =
        object.destinationEntity.runtimeType.toString() == 'ManagedEntity' &&
            !object.declaredType.toString().contains('ManagedSet<');
  } catch (e) {
    //
  }

  return managed;
}
