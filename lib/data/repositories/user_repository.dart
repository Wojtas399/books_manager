import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/synchronizers/user_synchronizer.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/models/device.dart';
import 'package:app/models/repository.dart';

class UserRepository extends Repository<User> implements UserInterface {
  late final UserSynchronizer _userSynchronizer;
  late final UserLocalDbService _userLocalDbService;
  late final UserRemoteDbService _userRemoteDbService;
  late final Device _device;

  UserRepository({
    required UserSynchronizer userSynchronizer,
    required UserLocalDbService userLocalDbService,
    required UserRemoteDbService userRemoteDbService,
    required Device device,
    List<User>? users,
  }) {
    _userSynchronizer = userSynchronizer;
    _userLocalDbService = userLocalDbService;
    _userRemoteDbService = userRemoteDbService;
    _device = device;

    if (users != null) {
      addEntities(users);
    }
  }

  @override
  Future<void> initializeUser({required String userId}) async {
    // if (await _device.hasInternetConnection()) {
    //   await _userSynchronizer.synchronizeUser(userId: userId);
    // }
  }

  @override
  Stream<User?> getUser({required String userId}) {
    return const Stream.empty();
    // return stream.map(
    //   (List<User>? users) {
    //     final List<User?> allUsers = [...?users];
    //     return allUsers.firstWhere(
    //       (User? user) => user?.id == userId,
    //       orElse: () => null,
    //     );
    //   },
    // );
  }

  @override
  Future<void> loadUser({required String userId}) async {
    // final User user = await _userRemoteDbService.loadUser(userId: userId);
    // addEntity(user);
  }

  @override
  Future<void> addUser({required User user}) async {
    // SyncState syncState = SyncState.added;
    // if (await _device.hasInternetConnection()) {
    //   await _userRemoteDbService.addUser(user: user);
    //   syncState = SyncState.none;
    // }
    // await _userLocalDbService.addUser(user: user, syncState: syncState);
    // addEntity(user);
  }

  @override
  Future<void> updateUserThemeSettings({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    // final User? originalUser = await getUser(userId: userId).first;
    // if (originalUser == null) {
    //   return;
    // }
    // final User updatedUser = originalUser.copyWith(
    //   isDarkModeOn: isDarkModeOn,
    //   isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    // );
    // updateEntity(updatedUser);
    // try {
    //   await _tryUpdateUserThemeSettings(
    //     userId,
    //     isDarkModeOn,
    //     isDarkModeCompatibilityWithSystemOn,
    //   );
    // } catch (_) {
    //   updateEntity(originalUser);
    // }
  }

  @override
  Future<void> deleteUser({required String userId}) async {
    // if (await _device.hasInternetConnection()) {
    //   await _userRemoteDbService.deleteUser(userId: userId);
    //   await _userLocalDbService.deleteUser(userId: userId);
    // } else {
    //   await _userLocalDbService.updateUser(
    //     userId: userId,
    //     syncState: SyncState.deleted,
    //   );
    // }
    // removeEntity(userId);
  }

  Future<void> _tryUpdateUserThemeSettings(
    String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  ) async {
    SyncState? syncState = SyncState.updated;
    if (await _device.hasInternetConnection()) {
      await _userRemoteDbService.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );
      syncState = SyncState.none;
    }
    await _userLocalDbService.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      syncState: syncState,
    );
  }
}
