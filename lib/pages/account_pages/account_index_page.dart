import 'package:flutter/material.dart';

import './../../helpers/static_functions.dart';
import './../../widgets/custom_sized_box.dart';
import './../../widgets/custom_app_bar.dart';
import './../reward_pages/reward_index_page.dart';
import './../coupon_pages/coupon_index_page.dart';
import './../voucher_pages/voucher_index_page.dart';
import './../transaction_history_pages/transaction_history_index_page.dart';
import './../download_pages/download_index_page.dart';

class AccountIndexPage extends StatefulWidget {
  @override
  _AccountIndexPageState createState() => _AccountIndexPageState();
}

class _AccountIndexPageState extends State<AccountIndexPage> {
  double _iconSize = 55;
  double _margin = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showSetting: true,
        showHighlight: true,
      ),
      body: Column(
        children: <Widget>[
          CustomSizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(_margin),
                    child: IconButton(
                      icon: Image.asset("assets/icons/account_tab_reward.png"),
                      iconSize: _iconSize,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RewardIndexPage()),
                        );
                      },
                    ),
                  ),
                  Text("Rewards")
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(_margin),
                    child: IconButton(
                      icon: Image.asset("assets/icons/account_tab_voucher.png"),
                      iconSize: _iconSize,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VoucherIndexPage()),
                        );
                      },
                    ),
                  ),
                  Text("Vouchers")
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(_margin),
                    child: IconButton(
                      icon: Image.asset("assets/icons/account_tab_coupon.png"),
                      iconSize: _iconSize,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CouponIndexPage()),
                        );
                      },
                    ),
                  ),
                  Text("Coupons")
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(_margin),
                    child: IconButton(
                      icon: Image.asset("assets/icons/account_tab_history.png"),
                      iconSize: _iconSize,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TransactionHistoryIndexPage()),
                        );
                      },
                    ),
                  ),
                  Text("History")
                ],
              ),
            ],
          ),
          CustomSizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: StaticFunctions.getDeviceWidth(context) * 0.035),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(_margin),
                    child: IconButton(
                      icon: Image.asset("assets/icons/account_tab_download.png"),
                      iconSize: _iconSize,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DownloadIndexPage()),
                        );
                      },
                    ),
                  ),
                  Text("Download")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
