import 'package:flutter/material.dart';

import './../../helpers/static_functions.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../widgets/custom_sized_box.dart';
import './../../apis/generic_apis.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_app_bar.dart';
import './../../helpers/extension_functions.dart';

class TransactionHistoryIndexPage extends StatefulWidget {
  @override
  _TransactionHistoryIndexPageState createState() => _TransactionHistoryIndexPageState();
}

class _TransactionHistoryIndexPageState extends State<TransactionHistoryIndexPage> {
  TransactionHistoryListingRequest _transactionHistoryListingRequest;
  TransactionHistoryListingResponse _transactionHistoryListingResponse;
  TransactionHistoryStampRequest _transactionHistoryStampRequest;
  TransactionHistoryStampResponse _transactionHistoryStampResponse;

  bool _isFirstLoad = true;
  final String _title = "Transaction History";

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
    final double _containerSize = StaticFunctions.getDeviceWidth(context) * 0.85;
    _transactionHistoryListingRequest = TransactionHistoryListingRequest(_userID);
    _transactionHistoryStampRequest = TransactionHistoryStampRequest(_userID);

    _transactionHistoryListingResponse = await GenericApis.transactionHistoryListingResponseApi(_transactionHistoryListingRequest);
    _transactionHistoryStampResponse = await GenericApis.transactionHistoryStampApi(_transactionHistoryStampRequest);

    _isFirstLoad = false;

    final List<Tab> _myTabs = <Tab>[
      Tab(text: 'Voucher'),
      Tab(text: 'Card'),
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
                return tab.text.toUpperCase() == _myTabs[0].text.toUpperCase() ? _constructHistoryListing(_containerSize) : _constructStampListing(_containerSize);
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _constructEmptyVoucher() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/pictures/record_empty.png"),
        CustomSizedBox(height: 5),
        Text(
          "No transactions",
          style: ThemeDesign.emptyStyle,
        ),
      ],
    );
  }

  Widget _constructHistoryListing(double containerSize) {
    var listingItems = List<TransactionHistoryListingItem>.from(_transactionHistoryListingResponse.redeemedItems);
    listingItems.addAll(List<TransactionHistoryListingItem>.from(_transactionHistoryListingResponse.expiredItems));

    return listingItems.isListEmpty()
        ? _constructEmptyVoucher()
        : Container(
            padding: ThemeDesign.containerPaddingLeftRightBottom,
            child: RefreshIndicator(
              onRefresh: () async {
                final _refreshedTransactionHistoryListingResponse = await GenericApis.transactionHistoryListingResponseApi(_transactionHistoryListingRequest);
                setState(() {
                  _transactionHistoryListingResponse = _refreshedTransactionHistoryListingResponse;
                });
              },
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listingItems.length,
                  itemBuilder: (context, index) {
                    final _listingItem = listingItems[index];

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: ThemeDesign.appPrimaryColor900, width: ThemeDesign.cardBorderWidth),
                        borderRadius: BorderRadius.circular(ThemeDesign.cardCornerRadius),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: containerSize,
                                    child: Text(
                                      _listingItem.voucherName,
                                      style: TextStyle(
                                        color: ThemeDesign.appPrimaryColor900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ThemeDesign.descriptionFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: containerSize,
                                    child: Text(
                                      _listingItem.voucherDescription,
                                      style: ThemeDesign.emptyStyle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: containerSize,
                                    child: Text(
                                      "${_listingItem.voucherRedeemDate ?? ""} ${_listingItem.voucherRedeemTime ?? ""}",
                                      style: ThemeDesign.emptyStyle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: containerSize,
                                    child: Text(
                                      _listingItem.voucherStatus,
                                      style: ThemeDesign.descriptionStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }

  Widget _constructStampListing(double containerSize) {
    return _transactionHistoryStampResponse.items.isListEmpty()
        ? _constructEmptyVoucher()
        : Container(
            padding: ThemeDesign.containerPaddingLeftRightBottom,
            child: RefreshIndicator(
              onRefresh: () async {
                final _refreshedTransactionHistoryStampResponse = await GenericApis.transactionHistoryStampApi(_transactionHistoryStampRequest);
                setState(() {
                  _transactionHistoryStampResponse = _refreshedTransactionHistoryStampResponse;
                });
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _transactionHistoryStampResponse.items.length,
                  itemBuilder: (context, index) {
                    final _stampItem = _transactionHistoryStampResponse.items[index];

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: ThemeDesign.appPrimaryColor900, width: ThemeDesign.cardBorderWidth),
                        borderRadius: BorderRadius.circular(ThemeDesign.cardCornerRadius),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: containerSize,
                                    child: Text(
                                      _stampItem.stampName,
                                      style: TextStyle(
                                        color: ThemeDesign.appPrimaryColor900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ThemeDesign.descriptionFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: containerSize,
                                    child: Text(
                                      _stampItem.stampType.toUpperCase() == "R" ? "Stamp Used: ${_stampItem.stampQuantity}" : "Stamp Get: ${_stampItem.stampQuantity}",
                                      style: ThemeDesign.emptyStyle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: containerSize,
                                    child: Text(
                                      _stampItem.transactionDate,
                                      style: ThemeDesign.emptyStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
