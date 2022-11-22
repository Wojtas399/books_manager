import 'package:app/models/entity.dart';
import 'package:app/models/state_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class TestEntity extends Entity {
  final String name;

  const TestEntity({
    required super.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}

class TestRepository extends StateRepository<TestEntity> {
  TestRepository({super.initialData});
}

void main() {
  late TestRepository repository;
  const List<TestEntity> existingEntities = [
    TestEntity(id: 'e1', name: 'name1'),
    TestEntity(id: 'e2', name: 'name2'),
  ];

  setUp(() {
    repository = TestRepository(initialData: existingEntities);
  });

  test(
    'add entities, should add entities to data stream without repetitions',
    () async {
      final List<TestEntity> newEntities = [
        existingEntities.first,
        const TestEntity(id: 'e3', name: 'name3'),
      ];
      final List<TestEntity> expectedEntities = [
        existingEntities.first,
        existingEntities[1],
        newEntities.last,
      ];

      repository.addEntities(newEntities);
      final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

      expect(await entities$.first, expectedEntities);
    },
  );

  test(
    'update entities, should update existing entities in data stream',
    () async {
      final List<TestEntity> updatedEntities = [
        TestEntity(id: existingEntities.first.id, name: 'n1'),
        const TestEntity(id: 'e3', name: 'name3'),
      ];
      final List<TestEntity> expectedEntities = [
        updatedEntities.first,
        existingEntities.last,
      ];

      repository.updateEntities(updatedEntities);
      final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

      expect(await entities$.first, expectedEntities);
    },
  );

  test(
    'remove entities, should remove entities from data stream',
    () async {
      final List<String> idsOfRemovedEntities = [existingEntities.last.id];
      final List<TestEntity> expectedEntities = [
        existingEntities.first,
      ];

      repository.removeEntities(idsOfRemovedEntities);
      final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

      expect(await entities$.first, expectedEntities);
    },
  );
}
