enum SyncState {
  added,
  updated,
  deleted,
  none,
}

extension StringExtensions on String {
  SyncState toSyncState() {
    switch (this) {
      case 'added':
        return SyncState.added;
      case 'updated':
        return SyncState.updated;
      case 'deleted':
        return SyncState.deleted;
      case 'none':
        return SyncState.none;
      default:
        return SyncState.none;
    }
  }
}
