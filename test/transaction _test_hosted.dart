import 'dart:convert';

import 'package:flutter_app/api_calls/wallet_api.dart';
import 'package:flutter_app/global.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WalletApi api = WalletApi();
  FaucetApi faucetApi = FaucetApi();
  // Public hosted URLs
  var grpcUrl = 'grpc.testnet.cosmos.network';
  var grcpPort = 443;
  var lcdUrl = 'api.testnet.cosmos.network';

  baseEnv.setEnv(grpcUrl, lcdUrl, grcpPort);

  test('Import Alice wallet', () {
    api.importWallet(
        mnemonicString:
            'brush bleak category link own under around element update either jungle trap base swamp fitness hour section skill soon bread cousin text evil jazz',
        walletAlias: 'Alice');
  });

  test('Import Bob wallet', () {
    api.importWallet(
        mnemonicString:
            'oak favorite woman uniform try initial grant craft sun copper aim arctic grape mansion floor apology false crash hold family veteran under wink loan',
        walletAlias: 'Bob');
  });

  test('Get first wallet balances', () async {
    var wallet = globalCache.wallets[0];
    var address = wallet.walletAddress;
    var balances = await api.getWalletBalances(address);
    print(wallet.walletAlias);
    balances.balances.forEach((element) {
      print(element.denom + ' ' + element.amount);
    });
  });

  test('Get second wallet balances', () async {
    var wallet = globalCache.wallets[1];
    var address = wallet.walletAddress;
    var balances = await api.getWalletBalances(address);
    print(wallet.walletAlias);
    balances.balances.forEach((element) {
      print(element.denom + ' ' + element.amount);
    });
  });

  test('Get free tokens for Alice', () async {
    var wallet = globalCache.wallets[0];
    var address = wallet.walletAddress;
    print('Getting free tokens for Alice');
    await faucetApi.getFreeTokens(address);
  });

  test('Get free tokens for Bob', () async {
    var wallet = globalCache.wallets[1];
    var address = wallet.walletAddress;
    print('Getting free tokens for Bob');
    await faucetApi.getFreeTokens(address);
  });

  test('Get first wallet balances', () async {
    var wallet = globalCache.wallets[0];
    var address = wallet.walletAddress;
    var balances = await api.getWalletBalances(address);
    print(wallet.walletAlias);
    balances.balances.forEach((element) {
      print(element.denom + ' ' + element.amount);
    });
  });

  test('Get second wallet balances', () async {
    var wallet = globalCache.wallets[1];
    var address = wallet.walletAddress;
    var balances = await api.getWalletBalances(address);
    print(wallet.walletAlias);
    balances.balances.forEach((element) {
      print(element.denom + ' ' + element.amount);
    });
  });

  test('Make a transaction from Alice to Bob', () async {
    await api.sendAmount(
      fromAddress: globalCache.wallets[0].walletAddress,
      toAddress: globalCache.wallets[1].walletAddress,
      amount: '10',
      denom: 'uphoton',
    );
  });

  test('Get first wallet balances', () async {
    var wallet = globalCache.wallets[0];
    var address = wallet.walletAddress;
    var balances = await api.getWalletBalances(address);
    print(wallet.walletAlias);
    balances.balances.forEach((element) {
      print(element.denom + ' ' + element.amount);
    });
  });

  test('Get second wallet balances', () async {
    var wallet = globalCache.wallets[1];
    var address = wallet.walletAddress;
    var balances = await api.getWalletBalances(address);
    print(wallet.walletAlias);
    balances.balances.forEach((element) {
      print(element.denom + ' ' + element.amount);
    });
  });
}

class FaucetApi {
  getFreeTokens(String address) async {
    final Uri uri = Uri.parse('https://faucet.testnet.cosmos.network/');
    await client.post(
      uri,
      body: jsonEncode(
        {
          "address": address,
          "coins": ["100uphoton"]
        },
      ),
    );
  }
}
