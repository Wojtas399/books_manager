import 'package:app/models/custom_repository.dart';
import 'package:app/models/entity.dart';
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

class TestRepository extends CustomRepository<TestEntity> {
  TestRepository({super.initialState});
}

void main() {
  late TestRepository repository;

  TestRepository createRepository({
    List<TestEntity>? initialState,
  }) {
    return TestRepository(
      initialState: initialState,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  test(
    'add entity, should add entity to data stream',
    () async {
      const TestEntity entity = TestEntity(id: 'e1', name: 'name');

      repository.addEntity(entity);
      final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

      expect(await entities$.first, [entity]);
    },
  );

  group(
    'update entity',
    () {
      const TestEntity updatedEntity = TestEntity(id: 'e1', name: 'new name');

      void methodCall() {
        repository.updateEntity(updatedEntity);
      }

      test(
        'entity does not exist in data stream, should do nothing',
        () async {
          methodCall();
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, null);
        },
      );

      test(
        'entity exists in data stream, should update entity in data stream',
        () async {
          const TestEntity entity = TestEntity(id: 'e1', name: 'name');
          repository = createRepository(initialState: [entity]);

          methodCall();
          final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

          expect(await entities$.first, [updatedEntity]);
        },
      );
    },
  );

  test(
    'remove entity, should remove entity from data stream',
    () async {
      const String entityId = 'e1';
      const TestEntity entity = TestEntity(id: entityId, name: 'name');
      repository = createRepository(initialState: [entity]);

      repository.removeEntity(entityId);
      final Stream<List<TestEntity>?> entities$ = repository.dataStream$;

      expect(await entities$.first, []);
    },
  );
}
