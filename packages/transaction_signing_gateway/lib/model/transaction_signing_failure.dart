import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';

enum TransactionSigningFailType {
  userDeclined,
  invalidPassword,
  noTransactionSignerFound,
  walletCredentialsStorageFailure,
  unknown,
}

abstract class TransactionSigningFailure {
  TransactionSigningFailType get type;
}

class TransactionSignerNotFoundFailure implements TransactionSigningFailure {
  const TransactionSignerNotFoundFailure();

  @override
  TransactionSigningFailType get type => TransactionSigningFailType.noTransactionSignerFound;
}

class UserDeclinedTransactionSignerFailure implements TransactionSigningFailure {
  const UserDeclinedTransactionSignerFailure();

  @override
  TransactionSigningFailType get type => TransactionSigningFailType.userDeclined;
}

class InvalidPasswordTransactionSignerFailure implements TransactionSigningFailure {
  const InvalidPasswordTransactionSignerFailure();

  @override
  TransactionSigningFailType get type => TransactionSigningFailType.invalidPassword;
}

class StorageProblemSigningFailure implements TransactionSigningFailure {
  const StorageProblemSigningFailure(this.failure);

  final CredentialsStorageFailure failure;

  @override
  TransactionSigningFailType get type => TransactionSigningFailType.walletCredentialsStorageFailure;

  @override
  String toString() {
    return 'StorageProblemSigningFailure{fail: $failure}';
  }
}
