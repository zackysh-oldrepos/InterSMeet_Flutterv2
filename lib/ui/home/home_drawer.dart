import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/models/degree.dart';
import 'package:intersmeet/core/models/drawer_menu_item.dart';
import 'package:intersmeet/core/models/user/user.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/routes/nav_items.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
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
  int selectedItem = -1;
  User? user;

  @override
  void initState() {
    user = authService.getUser();
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
            user?.degree = degrees.firstWhere((degree) => degree.degreeId == user?.degreeId);
          }

          // @ Build UI
          double width = MediaQuery.of(context).size.width;
          var _widget = !isExpanded ? itemIconOnly() : itemIconAndText();

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

  Widget itemIconAndText() {
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
                    bool selected = selectedItem == index;
                    return ExpansionTile(
                        onExpansionChanged: (z) {
                          setState(() {
                            selectedItem = z ? index : -1;
                          });
                        },
                        leading: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                          ),
                        ),
                        title: TextTile(
                          useoverflow: true,
                          text: item.title,
                          color: Colors.white,
                        ),
                        tilePadding: EdgeInsets.zero,
                        trailing: item.submenus.isEmpty
                            ? const SizedBox()
                            : Icon(
                                selected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                        children: item.submenus.map((subMenu) {
                          return subMenuButton(subMenu, false);
                        }).toList());
                  },
                ),
              ),
              accountIconOnly(),
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
        onTap: expandOrShrinkDrawer,
      ),
    );
  }

  Widget itemIconOnly() {
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
                            setState(() {
                              // navigate hete
                              selectedItem = index;
                            });
                            Navigator.pushNamed(context, navItems[index].route);
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
              accountButton(),
            ],
          ),
        ),
      ],
    );
  }

  // @ Sub-menu

  // Side sub-menus builder for icon-only items.
  Widget invisibleSideSubMenu() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: isExpanded ? 0 : 125,
      child: Column(
        children: [
          Container(height: 95),
          Expanded(
            child: ListView.builder(
                itemCount: navItems.length,
                itemBuilder: (context, index) {
                  DrawerMenuItem cmd = navItems[index];
                  bool selected = selectedItem == index;
                  bool isValidSubMenu = selected && cmd.submenus.isNotEmpty;
                  return subMenuWidget([cmd.title, ...cmd.submenus], isValidSubMenu);
                }),
          ),
        ],
      ),
    );
  }

  // Side sub-menu body.
  Widget subMenuWidget(List<String> submenus, bool isValidSubMenu) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: isValidSubMenu ? submenus.length.toDouble() * 37.5 : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isValidSubMenu ? Colorz.complexDrawerBlueGrey : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: ListView.builder(
          padding: const EdgeInsets.all(6),
          itemCount: isValidSubMenu ? submenus.length : 0,
          itemBuilder: (context, index) {
            String subMenu = submenus[index];
            return subMenuButton(subMenu, index == 0);
          }),
    );
  }

  // @ Buttons

  // Button which controls whether the drawer is expanded or shrinked.
  Widget drawerButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: expandOrShrinkDrawer,
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

  Widget accountButton({bool usePadding = true}) {
    return Padding(
      padding: EdgeInsets.all(usePadding ? 8 : 0),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 20.0,
              spreadRadius: 2.0,
            )
          ]),
          child: ClipOval(
            child: user?.avatar != null
                ? imageFromList(user!.avatar!)
                : Image.asset("assets/images/avatar-placeholder.png"),
          ),
        ),
      ),
    );
  }

  Widget accountIconOnly() {
    if (user != null) {
      return Container(
        color: Colorz.complexDrawerBlueGrey,
        child: ListTile(
          leading: accountButton(usePadding: false),
          title: TextTile(
            text: "${upperFirst(user!.firstName)} ${upperFirst(user!.lastName)}",
            color: Colors.white,
          ),
          subtitle: TextTile(
            text: "${upperEachFirst(user!.degree!.name)}",
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      );
    }
    return const SizedBox();
  }

  void expandOrShrinkDrawer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}
