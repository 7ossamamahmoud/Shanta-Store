import 'package:flutter/material.dart';
import 'package:salla/models/on_boarding_model.dart';
import 'package:salla/screens/login_screen.dart';
import 'package:salla/screens/widgets/on_boarding_item.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/network/local/shared_preference_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static String onBoardingScreenID = "onBoardingScreenID";

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast = false;
  final List<OnBoardingModel> onBoardingList = [
    OnBoardingModel(
      imgPath: 'assets/images/onboard.jpg',
      title: 'Shop Anytime, Anywhere',
      body: 'Experience the freedom of shopping at your fingertips, 24/7.',
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboard.jpg',
      title: 'Your Ultimate Shopping Companion',
      body:
          'Our app is designed to make your shopping journey effortless and enjoyable.',
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboard.jpg',
      title: 'Unlock Exclusive Deals',
      body:
          'Join now to access special promotions and make the most of your shopping adventure!',
    ),
  ];
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
            child: const Text('SKIP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                )),
            onPressed: () {
              onBoardingSubmit(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (index == onBoardingList.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  return OnBoardingItem(
                    onBoardingModel: onBoardingList[index],
                  );
                },
                itemCount: onBoardingList.length,
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  effect: const ExpandingDotsEffect(
                    expansionFactor: 5,
                    dotHeight: 10,
                    dotWidth: 10,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                  ),
                  count: onBoardingList.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      onBoardingSubmit(context);
                    } else {
                      pageController.nextPage(
                        duration: const Duration(
                          milliseconds: 800,
                        ),
                        curve: Curves.easeInOutCubicEmphasized,
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  void onBoardingSubmit(BuildContext context) {
    SharedPrefService.saveData(key: 'onBoarding', value: true).then((value) {
      navigateAndFinish(
        context,
        LoginScreen.loginScreenID,
      );
    });
  }
}
