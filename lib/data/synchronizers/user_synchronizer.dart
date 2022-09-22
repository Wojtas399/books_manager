import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/models/db_user.dart';

class UserSynchronizer {
  late final UserLocalDbService _userLocalDbService;
  late final UserRemoteDbService _userRemoteDbService;

  UserSynchronizer({
    required UserLocalDbService userLocalDbService,
    required UserRemoteDbService userRemoteDbService,
  }) {
    _userLocalDbService = userLocalDbService;
    _userRemoteDbService = userRemoteDbService;
  }

  Future<void> synchronizeUser({required String userId}) async {
    if (await _userLocalDbService.doesUserExist(userId: userId)) {
      await _manageUserSyncStateFromLocalDb(userId);
    } else {
      await _addUserFromRemoteDbToLocalDb(userId);
    }
  }

  Future<void> _manageUserSyncStateFromLocalDb(String userId) async {
    final SyncState userSyncState =
        await _userLocalDbService.loadUserSyncState(userId: userId);
    switch (userSyncState) {
      case SyncState.added:
        await _addUserFromLocalDbToRemoteDb(userId);
        break;
      case SyncState.updated:
        await _updateUserFromLocalDbInRemoteDb(userId);
        break;
      case SyncState.deleted:
        await _deleteUserInBothDatabases(userId);
        break;
      case SyncState.none:
        await _updateUserFromRemoteDbInLocalDb(userId);
        break;
    }
  }

  Future<void> _addUserFromLocalDbToRemoteDb(String userId) async {
    final DbUser localDbUser = await _userLocalDbService.loadUser(
      userId: userId,
    );
    await _userRemoteDbService.addUser(dbUser: localDbUser);
    await _updateUserSyncStateToNoneInLocalDb(userId);
  }

  Future<void> _updateUserFromLocalDbInRemoteDb(String userId) async {
    final DbUser localDbUser = await _userLocalDbService.loadUser(
      userId: userId,
    );
    await _userRemoteDbService.updateUser(
      userId: userId,
      isDarkModeOn: localDbUser.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          localDbUser.isDarkModeCompatibilityWithSystemOn,
    );
    await _updateUserSyncStateToNoneInLocalDb(userId);
  }

  Future<void> _deleteUserInBothDatabases(String userId) async {
    await _userRemoteDbService.deleteUser(userId: userId);
    await _userLocalDbService.deleteUser(userId: userId);
  }

  Future<void> _updateUserFromRemoteDbInLocalDb(String userId) async {
    final DbUser remoteDbUser = await _userRemoteDbService.loadUser(
      userId: userId,
    );
    await _userLocalDbService.updateUser(
      userId: userId,
      isDarkModeOn: remoteDbUser.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          remoteDbUser.isDarkModeCompatibilityWithSystemOn,
    );
  }

  Future<void> _addUserFromRemoteDbToLocalDb(String userId) async {
    final DbUser remoteDbUser = await _userRemoteDbService.loadUser(
      userId: userId,
    );
    await _userLocalDbService.addUser(dbUser: remoteDbUser);
  }

  Future<void> _updateUserSyncStateToNoneInLocalDb(String userId) async {
    await _userLocalDbService.updateUser(
      userId: userId,
      syncState: SyncState.none,
    );
  }
}
