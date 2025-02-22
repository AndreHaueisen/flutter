import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transaction_signing_gateway/model/credentials_storage_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/model/wallet_lookup_key.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import 'mocks/key_info_storage_mock.dart';
import 'mocks/private_wallet_credentials_mock.dart';
import 'mocks/transaction_summary_ui_mock.dart';

void main() {
  group('Mock TransactionSummary', () {
    late TransactionSummaryUIMock summaryUI;
    late KeyInfoStorageMock infoStorage;
    late TransactionSigningGateway signingGateway;
    const chainId = 'atom';
    const walletId = '123walletId';
    const publicAddress = 'cosmos1wze8mn5nsgl9qrgazq6a92fvh7m5e6psjcx2du';
    const name = 'name';
    const mnemonic =
        'fruit talent run shallow police ripple wheat original cabbage vendor tilt income gasp meat acid annual armed system target great oxygen artist net elegant';
    const privateCredsStub = PrivateWalletCredentialsMock(
      publicInfo: WalletPublicInfo(
        name: name,
        publicAddress: publicAddress,
        walletId: walletId,
        chainId: chainId,
      ),
      mnemonic: mnemonic,
    );

    test('declining ui returns failure', () async {
      // GIVEN
      when(summaryUI.showTransactionSummaryUI(transaction: anyNamed('transaction')))
          .thenAnswer((_) async => left(const UserDeclinedTransactionSignerFailure()));
      // WHEN
      final result = await signingGateway.signTransaction(
        transaction: UnsignedTransaction(),
        walletLookupKey: const WalletLookupKey(
          chainId: chainId,
          password: 'password',
          walletId: walletId,
        ),
      );
      // THEN
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => r), isA<UserDeclinedTransactionSignerFailure>());
      verifyNever(infoStorage.getPrivateCredentials(any));
    });

    test('failing to retrieve key returns failure', () async {
      // GIVEN
      when(summaryUI.showTransactionSummaryUI(transaction: anyNamed('transaction')))
          .thenAnswer((_) async => right(unit));
      when(infoStorage.getPrivateCredentials(any)) //
          .thenAnswer((_) async => left(const CredentialsStorageFailure('fail')));
      // WHEN
      final result = await signingGateway.signTransaction(
        transaction: UnsignedTransaction(),
        walletLookupKey: const WalletLookupKey(
          chainId: chainId,
          password: 'password',
          walletId: walletId,
        ),
      );
      // THEN
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => r), isA<TransactionSigningFailure>());
      verify(summaryUI.showTransactionSummaryUI(transaction: anyNamed('transaction')));
    });

    test('missing proper signer returns failure', () async {
      // GIVEN
      when(summaryUI.showTransactionSummaryUI(transaction: anyNamed('transaction')))
          .thenAnswer((_) async => right(unit));
      when(infoStorage.getPrivateCredentials(any)).thenAnswer((_) async => right(privateCredsStub));
      // WHEN
      final result = await signingGateway.signTransaction(
        transaction: UnsignedTransaction(),
        walletLookupKey: const WalletLookupKey(
          chainId: chainId,
          password: 'password',
          walletId: walletId,
        ),
      );
      // THEN
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => r), isA<TransactionSignerNotFoundFailure>());
      verify(summaryUI.showTransactionSummaryUI(transaction: anyNamed('transaction')));
      verify(infoStorage.getPrivateCredentials(any));
    });

    setUp(() {
      summaryUI = TransactionSummaryUIMock();
      infoStorage = KeyInfoStorageMock();
      signingGateway = TransactionSigningGateway(
        transactionSummaryUI: summaryUI,
        signers: [],
        broadcasters: [],
        infoStorage: infoStorage,
        derivators: [],
      );
    });
  });
}
