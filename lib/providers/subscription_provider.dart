import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SubscriptionNotifier(storage);
});

class SubscriptionNotifier extends StateNotifier<bool> {
  final StorageService _storage;

  SubscriptionNotifier(this._storage) : super(_storage.isSubscribed);

  Future<void> subscribe() async {
    await _storage.setSubscribed(true);
    state = true;
  }

  Future<void> unsubscribe() async {
    await _storage.setSubscribed(false);
    state = false;
  }
}
