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

  TestRepository createRepository({
    List<TestEntity>? initialData,
  }) {
    return TestRepository(initialData: initialData);
  }

  setUp(() {
    repository = createRepository();
  });

  group(
    'add entities',
    () {
      void methodCall(List<TestEntity> entitiesToAdd) {
        repository.addEntities(entitiesToAdd);
      }

      test(
        'value of data stream is null, given list of entities is empty, should do nothing',
        () async {
          final List<TestEntity> entitiesToAdd = [];

          methodCall(entitiesToAdd);
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, null);
        },
      );

      test(
        'value of data stream is not null, should add entities to data stream without repetitions',
        () async {
          final List<TestEntity> entitiesToAdd = [
            existingEntities.first,
            const TestEntity(id: 'e3', name: 'name3'),
          ];
          final List<TestEntity> expectedEntities = [
            existingEntities.first,
            existingEntities[1],
            entitiesToAdd.last,
          ];
          repository = createRepository(initialData: existingEntities);

          methodCall(entitiesToAdd);
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, expectedEntities);
        },
      );
    },
  );

  group(
    'update entities',
    () {
      void methodCall(List<TestEntity> entitiesToUpdate) {
        repository.updateEntities(entitiesToUpdate);
      }

      test(
        'value of data stream is null, should not change value of data stream',
        () async {
          final List<TestEntity> entitiesToUpdate = [
            TestEntity(id: existingEntities.first.id, name: 'n1'),
          ];

          methodCall(entitiesToUpdate);
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, null);
        },
      );

      test(
        'value of data stream is not null, should update existing entities in data stream',
        () async {
          final List<TestEntity> entitiesToUpdate = [
            TestEntity(id: existingEntities.first.id, name: 'n1'),
            const TestEntity(id: 'e3', name: 'name3'),
          ];
          final List<TestEntity> expectedEntities = [
            entitiesToUpdate.first,
            existingEntities.last,
          ];
          repository = createRepository(initialData: existingEntities);

          methodCall(entitiesToUpdate);
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, expectedEntities);
        },
      );
    },
  );

  group(
    'remove entities',
    () {
      void methodCall(List<String> idsOfEntitiesToRemove) {
        repository.removeEntities(idsOfEntitiesToRemove);
      }

      test(
        'value of data stream is null, should do nothing',
        () async {
          final List<String> idsOfEntitiesToRemove = [
            existingEntities.first.id,
          ];

          methodCall(idsOfEntitiesToRemove);
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, null);
        },
      );

      test(
        'value of data stream is not null, should remove entities from data stream',
        () async {
          final List<String> idsOfEntitiesToRemove = [existingEntities.last.id];
          final List<TestEntity> expectedEntities = [
            existingEntities.first,
          ];
          repository = createRepository(initialData: existingEntities);

          methodCall(idsOfEntitiesToRemove);
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, expectedEntities);
        },
      );
    },
  );
}
