import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/storage/data_store.dart';

typedef SharedPrefsProvider = Future<SharedPreferences> Function();

class SharedPrefsPlainDataStore implements PlainDataStore {
  SharedPrefsPlainDataStore({
    SharedPrefsProvider? sharedPreferencesProvider,
  }) : sharedPreferencesProvider = sharedPreferencesProvider ?? SharedPreferences.getInstance;

  static const String keyPrefix = 'cosmosSharedPrefs_';

  final SharedPrefsProvider sharedPreferencesProvider;

  @override
  Future<Either<CredentialsStorageFailure, Map<String, String?>>> readAllPlainText() async {
    try {
      final prefs = await sharedPreferencesProvider();
      return right(
        Map.fromEntries(
          prefs.getKeys().where((it) => it.startsWith(keyPrefix)).map(
                (key) => MapEntry(
                  key.replaceFirst(keyPrefix, ''),
                  prefs.getString(key),
                ),
              ),
        ),
      );
    } catch (ex, stack) {
      return left(CredentialsStorageFailure('Error while reading all plain text data', cause: ex, stack: stack));
    }
  }

  @override
  Future<Either<CredentialsStorageFailure, String?>> readPlainText({
    required String key,
  }) async {
    try {
      final prefs = await sharedPreferencesProvider();
      return right(prefs.getString('$keyPrefix$key'));
    } catch (ex, stack) {
      return left(CredentialsStorageFailure("Error while reading plain text for key: '$key'", cause: ex, stack: stack));
    }
  }

  @override
  Future<Either<CredentialsStorageFailure, Unit>> savePlainText({required String key, required String? value}) async {
    try {
      final prefs = await sharedPreferencesProvider();
      if (value == null) {
        await prefs.remove('$keyPrefix$key');
      } else {
        await prefs.setString('$keyPrefix$key', value);
      }
      return right(unit);
    } catch (ex, stack) {
      return left(CredentialsStorageFailure("Error while setting plain text for key: '$key'", cause: ex, stack: stack));
    }
  }
}
