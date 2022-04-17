
import 'package:flutter/cupertino.dart';

import '../utils/tab_items.dart';

class MyCustomBottomNavigation extends StatefulWidget {
   const MyCustomBottomNavigation(
      {Key? key,
        required this.currentTab,
        required this.onSelectedTab,
        required this.pageCreator,
        required this.navigatorKeys}): super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  State<MyCustomBottomNavigation> createState() => _MyCustomBottomNavigationState();
}

class _MyCustomBottomNavigationState extends State<MyCustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(tabBar: CupertinoTabBar(items: [
      _navItemOlustur(TabItem.users),
      _navItemOlustur(TabItem.profile),

    ],
      onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
    ), tabBuilder: (context, index){
      final willShowItem = TabItem.values[index];
      return CupertinoTabView(
          navigatorKey: widget.navigatorKeys[willShowItem],
          builder: (context) {
            return widget.pageCreator[willShowItem]!;
          });
    });
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final willCreatingTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(willCreatingTab?.icon),
      label: willCreatingTab!.title,
    );
  }
}
