import 'package:app/models/entity.dart';
import 'package:rxdart/rxdart.dart';

class CustomRepository<T extends Entity> {
  final BehaviorSubject<List<T>?> _dataStream =
      BehaviorSubject<List<T>?>.seeded(null);

  CustomRepository({List<T>? initialState}) {
    _dataStream.add(initialState);
  }

  Stream<List<T>?> get dataStream$ => _dataStream.stream;

  void close() {
    _dataStream.close();
  }

  void addEntity(T entity) {
    final List<T> updatedData = [...?_dataStream.value];
    updatedData.add(entity);
    _dataStream.add(updatedData);
  }

  void updateEntity(T updatedEntity) {
    final List<T> updatedData = [...?_dataStream.value];
    final int entityIndex = updatedData.indexWhere(
      (T entity) => entity.id == updatedEntity.id,
    );
    if (entityIndex >= 0) {
      updatedData[entityIndex] = updatedEntity;
      _dataStream.add(updatedData);
    }
  }

  void removeEntity(String removedEntityId) {
    final List<T> updatedData = [...?_dataStream.value];
    updatedData.removeWhere((T entity) => entity.id == removedEntityId);
    _dataStream.add(updatedData);
  }
}
