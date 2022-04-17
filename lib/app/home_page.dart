import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/app/profile_page.dart';
import 'package:flutter_lovers_app/app/user_page.dart';
import 'package:flutter_lovers_app/model/MyUser.dart';
import 'package:flutter_lovers_app/utils/tab_items.dart';

import 'my_custom_bottom_navi.dart';

class HomePage extends StatefulWidget {
  MyUser myUser;

  HomePage({Key? key,required this.myUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TabItem _currentTab = TabItem.users;

  Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.users: const UsersPage(),
      TabItem.profile: const ProfilePage(),
    };
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: MyCustomBottomNavigation(
      pageCreator: allPages(),
      navigatorKeys: navigatorKeys,
      currentTab: _currentTab,
      onSelectedTab: (selectedTab){
        if(selectedTab == _currentTab){
          navigatorKeys[selectedTab]?.currentState?.popUntil((route) => route.isFirst);
        }else{
          setState(() {
            _currentTab=selectedTab;
          });
        }
      },
    ), onWillPop: () async => !await navigatorKeys[_currentTab]!.currentState!.maybePop());
  }
}
