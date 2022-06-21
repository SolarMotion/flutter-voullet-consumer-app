import 'package:flutter/material.dart';
import 'package:flutter_voullet_consumer_app/pages/reward_pages/reward_stamp_balance_details_page.dart';

import './../../pages/shared_pages/empty_page.dart';
import './../../apis/reward_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import '../../helpers/static_functions.dart';
import '../shared_pages/loading_page.dart';
import '../../resources/theme_designs.dart';
import '../../widgets/custom_app_bar.dart';
import './../../helpers/extension_functions.dart';

class RewardStampBalancePage extends StatefulWidget {
  final int orgID;

  RewardStampBalancePage({Key key, @required this.orgID}) : super(key: key);

  @override
  _RewardStampBalancePageState createState() => _RewardStampBalancePageState();
}

class _RewardStampBalancePageState extends State<RewardStampBalancePage> {
  final String _title = "Card List";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStampBalanceDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return snapshot.data;
        } else {
          return Scaffold(
            appBar: CustomAppBar(
              title: _title,
            ),
            body: LoadingPage(),
          );
        }
      },
    );
  }

  Future<Widget> _getStampBalanceDetails() async {
    final double _containerWidth = StaticFunctions.getDeviceWidth(context) * 0.85;
    final double _containerHeight = StaticFunctions.getDeviceHeight(context) * 0.3;
    final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    RewardStampBalancesRequest _rewardStampBalanceRequest = RewardStampBalancesRequest(widget.orgID, _userID);
    RewardStampBalancesResponse _rewardStampBalanceResponse = await RewardApis.rewardStampBalancesApi(_rewardStampBalanceRequest);

    return Scaffold(
      appBar: CustomAppBar(
        title: _title,
      ),
      body: _rewardStampBalanceResponse.error.isStringEmpty()
          ? _rewardStampBalanceResponse.rewardStampBalanceItems.isListEmpty()
              ? EmptyPage()
              : Container(
                  padding: ThemeDesign.containerPaddingLeftRightBottom,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final _refreshedRewardStampBalanceResponse = await RewardApis.rewardStampBalancesApi(_rewardStampBalanceRequest);
                      setState(() {
                        _rewardStampBalanceResponse = _refreshedRewardStampBalanceResponse;
                      });
                    },
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _rewardStampBalanceResponse.rewardStampBalanceItems.length,
                        itemBuilder: (context, index) {
                          final _stamp = _rewardStampBalanceResponse.rewardStampBalanceItems[index];

                          return GestureDetector(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: ThemeDesign.appPrimaryColor900, width: ThemeDesign.cardBorderWidth),
                                borderRadius: BorderRadius.circular(ThemeDesign.cardCornerRadius),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Image.memory(
                                _stamp.stampImageBytes,
                                width: _containerWidth,
                                height: _containerHeight,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => RewardStampBalanceDetailsPage(
                                    stampID: _stamp.stampID,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
          : EmptyPage(text: _rewardStampBalanceResponse.error),
    );
  }
}
