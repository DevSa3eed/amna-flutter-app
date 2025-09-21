import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/core/assets_getter/asset.dart';
import 'package:dr_sami/core/assets_getter/assets_getter.dart';
import 'package:dr_sami/core/constant_widgets/circle_progress.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/home_screen/baners/cubit/banners_cubit.dart';
import 'package:dr_sami/featurs/home_screen/baners/edite_banner.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'model/banner_model.dart';

class BannersView extends StatelessWidget {
  const BannersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BannersCubit()..getAllBanners(),
      child: BlocConsumer<BannersCubit, BannersState>(
        listener: (context, state) {
          if (state is GetAllBannersSuccessful) {
            showToast(content: state.message);
          } else if (state is GetBannersFailed) {
            showToast(content: state.message);
          } else if (state is DeleteBannerSuccessful ||
              state is EditBannerSuccessful) {
            context.read<BannersCubit>().getAllBanners();
            // Navigator.pushNamed(context, Routes.homeRoute);
          }
        },
        builder: (context, state) {
          var cubit = BannersCubit().get(context);
          return (cubit.listOfBanners?.isEmpty ?? true)
              ? Container(
                  margin: EdgeInsets.all(15.w),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Colours.DarkBlue),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: AssetsGetter.GetImage(
                          imageUrI: Assets.logo,
                          boxFit: BoxFit.cover,
                          imageWidth: 200.w,
                          imageHeghit: 200.h,
                          color: Colours.White),
                    ),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colours.White,
                  ),
                  child: CarouselSlider(
                    items: List.generate(
                      cubit.listOfBanners?.length ?? 0,
                      (int i) => ConditionBuilder(
                        condition: state is GetBannersLoading,
                        ifFalse: OneBanner(
                          bannerUiModel: cubit.listOfBanners?[i],
                        ),
                      ),
                    ),
                    options: CarouselOptions(
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      pauseAutoPlayOnTouch: true,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      aspectRatio: 2.0,
                      initialPage: 2,
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class OneBanner extends StatelessWidget {
  OneBanner({required this.bannerUiModel, super.key});
  Banners? bannerUiModel;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BlocBuilder<BannersCubit, BannersState>(
        builder: (context, state) {
          return Container(
              height: MediaQuery.of(context).size.height / 4,
              // width: MediaQuery.of(context).size.width - 20.w,
              decoration: BoxDecoration(
                color: Colours.LightBlue,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: '$imageUrl${bannerUiModel?.image ?? ''}',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          customLoader(), // While loading
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error), // If there is an error
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        bannerUiModel?.titel ?? '',
                        style: TextStyles.white16blod,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        bannerUiModel?.description ?? '',
                        style: TextStyles.white16blod,
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  (isAdmin ?? false)
                      ? Padding(
                          padding: EdgeInsets.all(5.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colours.White,
                                radius: 20.r,
                                child: IconButton(
                                    onPressed: () {
                                      if (bannerUiModel != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditBanner(
                                                bannerModel: bannerUiModel!),
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colours.DarkBlue,
                                    )),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              CircleAvatar(
                                backgroundColor: Colours.White,
                                radius: 20.r,
                                child: IconButton(
                                    onPressed: () {
                                      if (bannerUiModel?.id != null) {
                                        context
                                            .read<BannersCubit>()
                                            .DeleteBanner(
                                                bannerId: bannerUiModel!.id!);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colours.DarkBlue,
                                    )),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ));
        },
      ),
    );
  }
}
