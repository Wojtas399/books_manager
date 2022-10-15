import 'package:app/extensions/list_extensions.dart';
import 'package:app/models/entity.dart';
import 'package:rxdart/rxdart.dart';

abstract class Repository<T extends Entity> {
  final BehaviorSubject<List<T>?> _entities$ =
      BehaviorSubject<List<T>?>.seeded(null);

  Stream<List<T>?> get stream => _entities$.stream;

  List<T>? get value => _entities$.value;

  void addEntity(T entity) {
    final List<T> updatedEntities = [...?_entities$.value];
    updatedEntities.add(entity);
    _entities$.add(updatedEntities.removeRepetitions());
  }

  void addEntities(List<T> entities) {
    final List<T> updatedEntities = [...?_entities$.value];
    updatedEntities.addAll(entities);
    _entities$.add(updatedEntities.removeRepetitions());
  }

  void updateEntity(T updatedEntity) {
    final List<T> updatedEntities = [...?_entities$.value];
    final int updatedEntityIndex = updatedEntities.indexWhere(
      (T entity) => entity.id == updatedEntity.id,
    );
    updatedEntities[updatedEntityIndex] = updatedEntity;
    _entities$.add(updatedEntities.removeRepetitions());
  }

  void removeEntity(String id) {
    final List<T> updatedEntities = [...?_entities$.value];
    updatedEntities.removeWhere((T entity) => entity.id == id);
    _entities$.add(updatedEntities.removeRepetitions());
  }

  void reset() {
    _entities$.add(null);
  }
}
