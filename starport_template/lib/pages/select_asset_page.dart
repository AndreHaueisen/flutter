import 'package:cosmos_ui_components/cosmos_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:starport_template/entities/balance.dart';
import 'package:starport_template/pages/transfer_asset_page.dart';
import 'package:starport_template/widgets/balance_card_list.dart';

class SelectAssetPage extends StatelessWidget {
  final List<Balance> balancesList;

  const SelectAssetPage({Key? key, required this.balancesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CosmosAppBar(leading: CosmosBackButton(), title: 'Select Asset'),
      body: Padding(
        padding: EdgeInsets.only(top: CosmosTheme.of(context).spacingXXL),
        child: BalanceCardList(
          balancesList: balancesList,
          onTapItem: (balance) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransferAssetPage(balance: balance)));
          },
        ),
      ),
    );
  }
}
