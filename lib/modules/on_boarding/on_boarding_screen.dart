import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:fristapp/modules/login/login_screen.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  late final String image;
  late final String titel;
  late final String body;
  BoardingModel({
    required this.image,
    required this.titel,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();
  var IsLast = false;

  List<BoardingModel> boaerding = [
    BoardingModel(
        image: 'assets/images/on1.jpg',
        body: 'You will be reassured if you have a hypoglycemic episode⌚📱',
        titel:
            'Connect your smart watch to Google fit app by your  gmail 📲 \n\nConnect your email to our app'),
    BoardingModel(
        image: 'assets/images/on2.jpg',
        titel: 'Just keep you watch 24 hour automatically monitoring mode ⌚',
        body: 'You will get suitable care by monitoring your vital signs 🔁'),
    BoardingModel(
        image: 'assets/images/on3.jpg',
        body: 'You will be always under observation 🌝',
        titel:
            'Type 1 diabetes  non invasive glucose monitoring won\'t be a challenge now 💫'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              onSubmit();
            },
            child: Text(
              'SKIP',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) => BuildBoardingItem(
                  boaerding[index],
                ),
                itemCount: boaerding.length,
                onPageChanged: (int index) {
                  if (index == boaerding.length - 1) {
                    IsLast = true;
                  } else {
                    IsLast = false;
                  }
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boaerding.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: defultColor,
                    expansionFactor: 4,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 5,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (IsLast) {
                      onSubmit();
                    } else {
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    CachHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      NavidetAndFinish(context, LoginScreen());
    });
  }

  Widget BuildBoardingItem(BoardingModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage('${model.image}'),
          ),
        ),
        Text(
          '${model.body}',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '${model.titel}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    );
  }
}
