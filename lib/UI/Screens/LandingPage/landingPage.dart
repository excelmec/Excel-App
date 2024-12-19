import '../../Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'Widgets/pages.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: blue700,
      key: introKey,
      pages: [
        PageViewModel(
          title: "",
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          bodyWidget: page(
            context,
            data[0]["title"],
            data[0]["description"],
            Image.asset('assets/Excel Logo23.png', height: 240),
          ),
        ),
        PageViewModel(
          title: "",
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          bodyWidget: page(
            context,
            data[1]["title"],
            data[1]["description"],
            Image.asset('assets/mascot.png',
                height: 256, fit: BoxFit.contain),
          ),
        ),
        PageViewModel(
          title: "",
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          bodyWidget: page(
            context,
            data[2]["title"],
            data[2]["description"],
            Image.asset('assets/rocket.png', height: 240),
            extra: CTAButton(context),
          ),
        ),
      ],
      onDone: () => onIntroEnd(context),
      showSkipButton: true,
      nextFlex: 1,
      skip: Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: white300,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      ),
      next: Icon(Icons.arrow_forward, color: white300),
      done: Text(''),
      dotsDecorator: DotsDecorator(
        activeColor: black300,
        size: Size(8.0, 8.0),
        color: white400,
      ),
    );
  }

  Widget CTAButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 32, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryPink,
            shape: const StadiumBorder(),
            elevation: 0),
        onPressed: () => onIntroEnd(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Get Started",
                style: TextStyle(
                  color: backgroundBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Icon(
                Icons.arrow_forward,
                color: backgroundBlue,
              )
            ],
          ),
        ),
      ),
    );
  }

  var data = [
    {
      "title": "Welcome to Excel 2023",
      "description":
          "Excel is the annual techno-managerial fest of Govt. Model Enginnering College. It’s the Nation’s second and South India’s first ever fest of it’s kind!"
    },
    {
      "title": "Hi! I\'m JUNO",
      "description":
          "Meet Excel\'s bubbly, pointy-eared mascot that is hyper-excited about all things tech and fun, Juno! Unable to sit still due to unbridled excitement, she is excited to have a blast at Excel with you!"
    },
    {
      "title": "Let\'s get into it!",
      "description":
          "Dive right in and explore 40+ events, inclusive of informative workshops, heated panels, competitions, and activities filled with madness for all!"
    },
  ];
}

void onIntroEnd(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstTime', false);
  Navigator.of(context).pop();
}
