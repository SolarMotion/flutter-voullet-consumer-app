import 'package:flutter/material.dart';
import 'package:flutter_voullet_consumer_app/pages/reward_pages/reward_stamp_balance_page.dart';
import 'package:flutter_voullet_consumer_app/pages/reward_pages/reward_subscribe_stamp_details_page.dart';

import './../../apis/reward_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../helpers/extension_functions.dart';
import '../../widgets/custom_app_bar.dart';

class RewardIndexPage extends StatefulWidget {
  @override
  _RewardIndexPageState createState() => _RewardIndexPageState();
}

class _RewardIndexPageState extends State<RewardIndexPage> {
  RewardOrgRequest _rewardOrgRequest;
  RewardOrgResponse _rewardOrgResponse;
  RewardStampBalanceOrgRequest _rewardStampBalanceOrgRequest;
  RewardStampBalanceOrgResponse _rewardStampBalanceOrgResponse;

  bool _isFirstLoad = true;
  final String _title = "Rewards";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getListing(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && !_isFirstLoad) {
          return snapshot.data;
        } else if (_isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(
              title: _title,
            ),
            body: LoadingPage(),
          );
        } else {
          return snapshot.data;
        }
      },
    );
  }

  Future<Widget> _getListing() async {
    final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    _rewardOrgRequest = RewardOrgRequest(_userID, 0);
    _rewardStampBalanceOrgRequest = RewardStampBalanceOrgRequest(_userID);

    _rewardOrgResponse = await RewardApis.rewardOrgApi(_rewardOrgRequest);
    _rewardStampBalanceOrgResponse = await RewardApis.rewardStampBalanceOrgApi(_rewardStampBalanceOrgRequest);

    _isFirstLoad = false;

    final List<Tab> _myTabs = <Tab>[
      Tab(text: 'Subscribe'),
      Tab(text: 'Cards'),
    ];

    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: _myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(
              color: ThemeDesign.appPrimaryColor900,
            ),
            backgroundColor: Colors.white,
            title: Text(
              _title,
              style: TextStyle(
                color: ThemeDesign.appPrimaryColor900,
                fontSize: ThemeDesign.titleFontSize,
              ),
            ),
            bottom: TabBar(
              isScrollable: false,
              indicatorWeight: 3,
              indicatorColor: ThemeDesign.appPrimaryColor900,
              labelColor: ThemeDesign.appPrimaryColor900,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontSize: ThemeDesign.titleFontSize),
              unselectedLabelStyle: TextStyle(fontSize: ThemeDesign.titleFontSize),
              tabs: _myTabs,
            ),
          ),
          body: TabBarView(
            children: _myTabs.map(
              (Tab tab) {
                return tab.text.toUpperCase() == _myTabs[0].text.toUpperCase() ? _buildSubscribeListing() : _buildStampBalanceListing();
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscribeListing() {
    return _rewardOrgResponse.rewardOrgItems.isListEmpty()
        ? ConstructEmptyText()
        : Container(
            padding: ThemeDesign.containerPaddingAll,
            child: RefreshIndicator(
              onRefresh: () async {
                final _refreshedRewardOrgResponse = await RewardApis.rewardOrgApi(_rewardOrgRequest);
                setState(() {
                  _rewardOrgResponse = _refreshedRewardOrgResponse;
                });
              },
              child: GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _rewardOrgResponse.rewardOrgItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  final _org = _rewardOrgResponse.rewardOrgItems[index];

                  return GestureDetector(
                    child: Card(
                      margin: EdgeInsets.all(6),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: ThemeDesign.appPrimaryColor900, width: ThemeDesign.cardBorderWidth),
                        borderRadius: BorderRadius.circular(ThemeDesign.cardCornerRadius),
                      ),
                      child: Image.memory(_org.orgImageBytes),
                    ),
                    onTap: () {
                      if (!_org.stampID.isIntegerEmpty()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => RewardSubscribeStampDetailsPage(
                              stampID: _org.stampID,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          );
  }

  Widget _buildStampBalanceListing() {
    return _rewardStampBalanceOrgResponse.rewardStampBalanceOrgItems.isListEmpty()
        ? ConstructEmptyText()
        : Container(
            padding: ThemeDesign.containerPaddingAll,
            child: RefreshIndicator(
              onRefresh: () async {
                final _refreshedRewardStampBalanceOrgResponse = await RewardApis.rewardStampBalanceOrgApi(_rewardStampBalanceOrgRequest);
                setState(() {
                  _rewardStampBalanceOrgResponse = _refreshedRewardStampBalanceOrgResponse;
                });
              },
              child: GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _rewardStampBalanceOrgResponse.rewardStampBalanceOrgItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  final _stamp = _rewardStampBalanceOrgResponse.rewardStampBalanceOrgItems[index];

                  return GestureDetector(
                    child: Card(
                      margin: EdgeInsets.all(6),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: ThemeDesign.appPrimaryColor900, width: ThemeDesign.cardBorderWidth),
                        borderRadius: BorderRadius.circular(ThemeDesign.cardCornerRadius),
                      ),
                      child: Image.memory(_stamp.orgImageBytes),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RewardStampBalancePage(
                            orgID: _stamp.orgID,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
  }
}

class ConstructEmptyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No items available",
        style: ThemeDesign.emptyStyle,
      ),
    );
  }
}
