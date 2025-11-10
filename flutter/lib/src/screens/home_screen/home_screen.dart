import 'package:flutter/material.dart';
import 'package:astro_music/config/size_config.dart';
import 'package:astro_music/provider/base_view.dart';
import 'package:astro_music/src/screens/discover_screen/discover_screen.dart';
import 'package:astro_music/src/screens/player_screen/player_screen.dart';
import 'package:astro_music/src/screens/premium_screen/premium_screen.dart';
import 'package:astro_music/src/screens/profile_screen/profile_screen.dart';
import 'package:astro_music/src/widgets/bottom_nav_bar.dart';
import 'package:astro_music/view/home_screen_view_model.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseView<HomeScreenViewModel>(
        onModelReady: (model) => {},
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Color(0xFF6B6887),
            body: PageView(
              controller: model.pageController,
              children: <Widget>[
                Body(
                  model: model,
                ),
                DiscoverScreen(),
                PlayerScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: CustomBottomNavbar(context, model),
          );
        });
  }
}
