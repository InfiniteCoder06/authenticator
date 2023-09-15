abstract class StorageService {
  Future<void> init();
  Future<void> put<T>(String key, T value);
  Future<T> get<T>(String key, {T? defaultValue});
  Future<void> clear();
  Future<void> purge();
  Future<void> close();
}
