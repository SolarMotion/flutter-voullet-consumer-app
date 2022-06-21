import 'package:flutter/material.dart';

import './../generic_pages/home_page.dart';
import './../../resources/theme_designs.dart';
import './../../pages/account_pages/account_index_page.dart';
import './../../pages/cart_pages/cart_index_page.dart';
import './../../pages/news_pages/news_index_page.dart';

class BottomNavigationBarPage extends StatefulWidget {
  @override
  _BottomNavigationBarPageState createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[HomePage(), NewsIndexPage(), CartIndexPage(), AccountIndexPage()];
  PageController pageController = PageController();

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('DEALS'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('NEWS'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('CART'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('ACCOUNT'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ThemeDesign.appPrimaryColor900,
        backgroundColor: Colors.white,
        selectedFontSize: 18,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
