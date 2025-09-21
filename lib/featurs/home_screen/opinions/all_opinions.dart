import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:dr_sami/featurs/home_screen/opinions/cubit/opinions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/config/config.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import 'add_your_oPinion.dart';
import 'widgets/opinion_card.dart';

class OpinonBulider extends StatefulWidget {
  const OpinonBulider({super.key});

  @override
  State<OpinonBulider> createState() => _OpinonBuliderState();
}

int opinion = 0;

class _OpinonBuliderState extends State<OpinonBulider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpinionsCubit()..getOpinions(),
      child: BlocConsumer<OpinionsCubit, OpinionsState>(
          listener: (context, state) {
        if (state is DeleteOpinionsSuccess) {
          context.read<OpinionsCubit>().getOpinions();
          // showToast(content: state.message);
        }
      }, builder: (context, state) {
        final cubit = OpinionsCubit().get(context);

        return cubit.listofOpinion.isEmpty
            ? const Center(child: AddYourOpinion())
            : Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.localization['custmoerOpinion'],
                      style: TextStyles.lightBlue20blod,
                    ),
                    CarouselSlider(
                      items: [
                        for (int i = 0; i < cubit.listofOpinion.length; i++)
                          CustomerOpinions(
                            model: cubit.listofOpinion[i],
                          ),
                      ],
                      options: CarouselOptions(
                        height: 200.h,
                        padEnds: false,
                        // enlargeCenterPage: false,
                        autoPlay: false,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 3000),

                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            opinion = index;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: opinion,
                        count: cubit.listofOpinion.length,
                        effect: ScrollingDotsEffect(
                          dotHeight: 8.0,
                          dotWidth: 8.0,
                          activeDotColor: Colours.LightBlue,
                          dotColor: Colors.grey,
                        ),
                        onDotClicked: (index) {
                          // _controller.animateToPage(index);
                        },
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
