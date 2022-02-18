import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/models/degree/degree.dart';
import 'package:intersmeet/core/models/ui/drawer_menu_item.dart';
import 'package:intersmeet/core/models/user/user.dart';
import 'package:intersmeet/core/routes/nav_items.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/ui/shared/br.dart';
import 'package:intersmeet/ui/shared/intersmeet_title.dart';
import 'package:intersmeet/ui/shared/text_utils.dart';
import 'package:intersmeet/ui/shared/txt_da.dart';

import '../../main.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  // @ Dependencies
  var userService = getIt<UserService>();
  var authService = getIt<AuthenticationService>();

  // @ State
  bool isExpanded = false; // is drawer expanded (icons + text or only-icons)
  late User user;

  @override
  void initState() {
    user = authService.getUser()!;
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return FutureBuilder(
        future: Future.wait([
          userService.findAllDegrees(),
          userService.findAllDegrees(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          // @ Load data
          if (snapshot.hasData && snapshot.data != null) {
            var degrees = snapshot.data![0] as List<Degree>;
            user.degree = degrees.firstWhere((degree) => degree.degreeId == user.degreeId);
          }

          // @ Build UI
          double width = MediaQuery.of(context).size.width;
          var _widget = !isExpanded ? navItemsIcon() : navItemsTile();

          return SafeArea(
            child: SizedBox(
              width: width,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _widget,
              ),
            ),
          );
        });
  }

  // -----------------------------------------------------------------------
  // @ Nav-Items
  // -----------------------------------------------------------------------

  // @ Drawer expanded

  Widget navItemsTile() {
    return Row(
      key: UniqueKey(),
      children: [
        Container(
          width: 200,
          color: Colorz.complexDrawerBlack,
          child: Column(
            children: [
              controlTile(),
              Expanded(
                child: ListView.builder(
                  itemCount: navItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    DrawerMenuItem item = navItems[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(context, navItems[index].route,
                              (Route<dynamic> route) => route.settings.name == 'home');
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              margin: const EdgeInsets.only(right: 25),
                              child: Icon(
                                item.icon,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Expanded(
                              child: TextTile(
                                fontSize: 15,
                                useoverflow: true,
                                text: item.title,
                                color: Colors.white,
                              ),
                            ),
                            br((62))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              accountTile(),
            ],
          ),
        ),
      ],
    );
  }

  // Tile for icon and text items to control drawer shrink/expand.
  Widget controlTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: ListTile(
        leading: const Image(
          image: AssetImage('assets/images/logo/logo-mini-white.png'),
          width: 50,
        ),
        title: const InterSMeetTitle(fontSize: 18, darkMode: true),
        onTap: _expandOrShrinkDrawer,
      ),
    );
  }

  // @ Drawer shrinked

  Widget navItemsIcon() {
    return Row(
      key: UniqueKey(),
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: 70,
          color: Colorz.complexDrawerBlack,
          child: Column(
            children: [
              drawerButton(),
              Expanded(
                child: ListView.builder(
                    itemCount: navItems.length,
                    itemBuilder: (contex, index) {
                      // if(index==0) return controlButton();
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(context, navItems[index].route,
                                (Route<dynamic> route) => route.settings.name == 'home');
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            child: Icon(navItems[index].icon, color: Colors.white),
                          ),
                        ),
                      );
                    }),
              ),
              accountIcon(),
            ],
          ),
        ),
      ],
    );
  }

  // @ Buttons

  // Button which controls whether the drawer is expanded or shrinked
  Widget drawerButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _expandOrShrinkDrawer,
          child: Container(
            height: 45,
            alignment: Alignment.center,
            child: const Image(
              image: AssetImage('assets/images/logo/logo-mini-white.png'),
              width: 45,
            ),
          ),
        ),
      ),
    );
  }

  // Button for items withoud sub-menus.
  Widget subMenuButton(String subMenu, bool isTitle) {
    return InkWell(
      onTap: () {
        // handle the function
        // Navigator.pushNamed(context, routeName)
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextTile(
          text: subMenu,
          fontSize: isTitle ? 17 : 14,
          color: isTitle ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // @ Account

  Widget avatar() {
    return CircleAvatar(backgroundImage: user.getAvatar());
  }

  Widget accountIcon() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openProfile(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: avatar(),
        ),
      ),
    );
  }

  Widget accountTile() {
    return Material(
      color: Colorz.complexDrawerBlueGrey,
      child: InkWell(
        onTap: () => _openProfile(),
        child: ListTile(
          leading: avatar(),
          title: TextTile(
            text: "${upperFirst(user.firstName)} ${upperFirst(user.lastName)}",
            color: Colors.white,
          ),
          subtitle: TextTile(
            text: "${upperEachFirst(user.degree!.name)}",
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _openProfile() {
    Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil(
      'profile',
      (Route<dynamic> route) => route.settings.name == 'home',
    );
  }

  void _expandOrShrinkDrawer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}
