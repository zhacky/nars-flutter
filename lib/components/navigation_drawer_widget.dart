import 'package:nars/constants.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/screens/contact_us/contact_us_screen.dart';
import 'package:nars/screens/in_app_browser/in_app_browser_screen.dart';
import 'package:nars/screens/test/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: kPrimaryColor,
        child: ListView(
          // padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          children: <Widget>[
            // const SizedBox(height: defaultPadding * 3),
            // buildMenuItem(
            //   text: 'FAQ',
            //   icon: Icons.question_answer_outlined,
            //   onClicked: () {},
            // ),
            const SizedBox(height: defaultPadding),
            buildMenuItem(
              text: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InAppBrowserScreen(
                      url: 'http://nars.today/privacy-policy/',
                      titleText: 'Privacy Policy',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: defaultPadding),
            buildMenuItem(
              text: 'Contact Us',
              icon: Icons.phone,
              onClicked: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ContactUsScreen(),
                //   ),
                // );
                Navigator.of(context).pushNamed('/contactus');
              },
            ),
            // const SizedBox(height: defaultPadding),
            // buildMenuItem(
            //   text: 'Test',
            //   icon: Icons.settings,
            //   onClicked: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => TestScreen(),
            //       ),
            //     );
            //   },
            // ),
            const SizedBox(height: defaultPadding),
            buildMenuItem(
              text: 'Clear Cache',
              icon: Icons.recycling,
              onClicked: () {
                DefaultCacheManager().emptyCache();
                imageCache.clear();
                imageCache.clearLiveImages();
              },
            ),
            const SizedBox(height: defaultPadding),
            const Divider(
              color: Colors.white70,
            ),
            const SizedBox(height: defaultPadding),
            buildMenuItem(
              text: 'Logout',
              icon: Icons.logout_outlined,
              onClicked: () async {
                await TokenPreferences.setToken('');
                await TokenPreferences.removeProfileId();
                await Provider.of<AuthService>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: defaultPadding),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
