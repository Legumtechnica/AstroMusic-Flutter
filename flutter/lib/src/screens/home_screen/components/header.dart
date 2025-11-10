import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:astro_music/src/screens/cosmic_dashboard/cosmic_dashboard_screen.dart';

Widget header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Your Cosmic Music Journey',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'SF Pro Display',
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                height: 1.2),
          ),
        ),
      ),
      // Cosmic Dashboard Button
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(CosmicDashboardScreen.routeName);
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFE94560).withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.auto_awesome,
            color: Color(0xFFE94560),
            size: 24,
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 20),
        width: 50,
        height: 50,
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/icons/user_bg.svg',
              height: 47,
              width: 47,
            ),
            Positioned(
              top: 6,
              left: 5.5,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: AssetImage('assets/images/user.png'),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
