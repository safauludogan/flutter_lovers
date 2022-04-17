
import 'package:flutter/material.dart';

enum TabItem {
  users,profile
}

class TabItemData{
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem,TabItemData> allTabs = {
    TabItem.users:
        TabItemData("Kullanıcıları",Icons.supervised_user_circle),
    TabItem.profile: TabItemData("Profil",Icons.person),
  };
}