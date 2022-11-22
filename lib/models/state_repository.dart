import 'package:app/extensions/list_extension.dart';
import 'package:app/models/entity.dart';
import 'package:rxdart/rxdart.dart';

class StateRepository<T extends Entity> {
  final BehaviorSubject<List<T>?> _dataStream =
      BehaviorSubject<List<T>?>.seeded(null);

  StateRepository({List<T>? initialData}) {
    _dataStream.add(initialData);
  }

  Stream<List<T>?> get dataStream$ => _dataStream.stream;

  void close() {
    _dataStream.close();
  }

  void addEntities(List<T> entities) {
    final List<T> updatedData = [...?_dataStream.value];
    updatedData.addAll(entities);
    _dataStream.add(updatedData.removeRepetitions());
  }

  void updateEntities(List<T> updatedEntities) {
    final List<T> updatedData = [...?_dataStream.value];
    for (final T updatedEntity in updatedEntities) {
      final int indexOfEntity = updatedData.indexWhere(
        (T entity) => entity.id == updatedEntity.id,
      );
      if (indexOfEntity >= 0) {
        updatedData[indexOfEntity] = updatedEntity;
      }
    }
    _dataStream.add(updatedData);
  }

  void removeEntities(List<String> idsOfRemovedEntities) {
    final List<T> updatedData = [...?_dataStream.value];
    for (final String removedEntityId in idsOfRemovedEntities) {
      updatedData.removeWhere(
        (T entity) => entity.id == removedEntityId,
      );
    }
    _dataStream.add(updatedData);
  }
}
