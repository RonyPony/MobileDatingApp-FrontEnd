import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inlove/screens/home.page.dart';
import 'package:inlove/screens/profile.page.dart';
import 'package:inlove/screens/setting.page.dart';

import '../screens/chat.page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  double spaceBtweenItems = .15;

  @override
  Widget build(BuildContext context) {
    bool isProfile =
        ModalRoute.of(context)?.settings.name == ProfileScreen.routeName;
    bool isHome = ModalRoute.of(context)?.settings.name == HomePage.routeName;

    bool isChat = ModalRoute.of(context)?.settings.name == ChatScreen.routeName;
    bool isSettings =
        ModalRoute.of(context)?.settings.name == SettingScreen.routeName;

    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: const Color(0xff1b1b1b),
            ),
            padding: const EdgeInsets.only(
              top: 7,
              bottom: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamedAndRemoveUntil(
                        context, ProfileScreen.routeName, (route) => false);
                  },
                  child: Container(
                    width: 50,
                    height: 40,
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 36.67,
                          height: 36.67,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: isProfile
                              ? SvgPicture.asset(
                                  'assets/profile.svg',
                                  color: Colors.white,
                                )
                              : SvgPicture.asset('assets/profile.svg'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*spaceBtweenItems),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomePage.routeName, (route) => false);
                  },
                  child: Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isHome
                        ? SvgPicture.asset(
                            'assets/home.svg',
                            color: Colors.white,
                          )
                        : SvgPicture.asset('assets/home.svg'),
                  ),
                ),
                 SizedBox(width: MediaQuery.of(context).size.width * spaceBtweenItems),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, ChatScreen.routeName, (route) => false);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isChat?SvgPicture.asset(
                            'assets/chat.svg',
                            color: Colors.white,
                          )
                        : SvgPicture.asset('assets/chat.svg'),
                  ),
                ),
                 SizedBox(width: MediaQuery.of(context).size.width * spaceBtweenItems),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, SettingScreen.routeName, (route) => false);
                  },
                  child: Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isSettings
                        ? SvgPicture.asset(
                            'assets/settings.svg',
                            color: Colors.white,
                          )
                        : SvgPicture.asset('assets/settings.svg'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
