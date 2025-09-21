import 'package:dr_sami/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/cached_constants/cached_constants.dart';
import '../../core/theme/Colors/coluors.dart';
import '../../core/theme/text_styles/text_styeles.dart';
import '../../network/local/cache_helper.dart';
import '../../routes/routes.dart';
import '../auth/widgets/custom_button.dart';
import 'model/onboarding_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

bool isLast = false;
int pindex = 0;

PageController pageindex = PageController();

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    List<OnBoardingModel> items = [
      OnBoardingModel(
        description: config.localization['ondes1'],
        image: 'assets/images/onBoarding/Doctors.png',
        title: config.localization['on1'],
      ),
      OnBoardingModel(
        description: config.localization['ondes2'],
        image: 'assets/images/onBoarding/Online.png',
        title: config.localization['on2'],
      ),
      OnBoardingModel(
        description: config.localization['ondes3'],
        image: 'assets/images/onBoarding/prescription.png',
        title: config.localization['on3'],
      ),
    ];

    void submit() {
      cacheHelper.SaveData(key: 'onBoarding', value: true).then(
        (value) {
          onBoarding = cacheHelper.getData('onBoarding');
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.homeRoute, (route) => false);
        },
      );
    }

    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        backgroundColor: Colours.White,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          cacheHelper.getData('onBoarding') == null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      pindex = 0;
                      isLast = false;
                    });
                    submit();
                  },
                  child: Text(
                    config.localization['skip'],
                    style: TextStyle(color: Colours.DarkBlue, fontSize: 15.sp),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (value) {
                pindex = value;
                if (value == items.length - 1) {
                  setState(() {
                    isLast = true;
                  });
                } else {
                  setState(() {
                    isLast = false;
                  });
                }
              },
              controller: pageindex,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10.0.w),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(
                          items[index].image,
                        ),
                        height: 280.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        items[index].title,
                        style: TextStyles.lightBlue24blod,
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0.h),
                          child: Center(
                            child: Text(
                              items[index].description,
                              style: TextStyles.gray15blod,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: items.length,
            ),
          ),
          CustomBotton(
              navigate_fun: () {
                if (isLast) {
                  setState(() {
                    submit();
                    pindex = 0;
                    isLast = false;
                  });
                } else {
                  pageindex.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              lable: isLast
                  ? config.localization['getstared']
                  : config.localization['next'],
              fontSize: 20.sp),
          SizedBox(
            height: 15.h,
          ),
          SmoothPageIndicator(
            controller: pageindex,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: Colours.LightBlue,
              dotColor: Colors.black12,
              dotHeight: 8.r,
              dotWidth: 15.r,
              spacing: 8.0.w,
            ),
          ),
          const SizedBox(
            height: 40.0,
          )
        ],
      ),
    );
  }
}
