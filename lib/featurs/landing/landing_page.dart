import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/config/config.dart';
import '../../core/theme/Colors/coluors.dart';
import '../../core/theme/text_styles/text_styeles.dart';
import '../../featurs/auth/widgets/custom_button.dart';
import '../../featurs/home_screen/opinions/all_opinions.dart';
import '../../featurs/home_screen/opinions/cubit/opinions_cubit.dart';
import '../../featurs/home_screen/teams/team_members.dart';
import '../../featurs/home_screen/clinic/clinics.dart';
import '../../routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Public landing page for non-authenticated users
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // Hide back button
        title: Text(
          config.localization['App Name'] ?? 'My Clinic',
          style: TextStyles.lightBlue20blod,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.loginRoute);
            },
            icon: const Icon(Icons.login),
            tooltip: config.localization['login'],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            _buildFeaturesSection(context),
            _buildClinicsSection(),
            _buildTestimonialsSection(),
            _buildTeamSection(),
            _buildCallToActionSection(context),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colours.DarkBlue, Colours.LightBlue],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 100.w,
            height: 100.w,
            color: Colours.White,
          ),
          SizedBox(height: 20.h),
          Text(
            config.localization['on1'] ?? 'Your Health Starts Here',
            style: TextStyles.white20blod.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            config.localization['clinicdes'] ??
                'Get a medical consultation at your home in just 30-45 minutes, without waiting, without worry or inconvenience.',
            style: TextStyles.white20blod.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: Colours.White.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CustomBotton(
                  navigate_fun: () {
                    Navigator.pushNamed(context, Routes.loginRoute);
                  },
                  lable: config.localization['login'],
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomBotton(
                  navigate_fun: () {
                    Navigator.pushNamed(context, Routes.eulaRoute);
                  },
                  lable: config.localization['register'],
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            config.localization['features'] ?? 'Our Services',
            style: TextStyles.lightBlue20blod.copyWith(
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 20.h),
          _buildFeatureCard(
            icon: Icons.phone,
            title:
                config.localization['requestMeeting'] ?? 'Voice Consultations',
            description: 'Connect with doctors through secure voice calls',
          ),
          SizedBox(height: 15.h),
          _buildFeatureCard(
            icon: Icons.home,
            title: 'Home Visits',
            description: 'Get medical care in the comfort of your home',
          ),
          SizedBox(height: 15.h),
          _buildFeatureCard(
            icon: Icons.schedule,
            title: '24/7 Availability',
            description: 'Access healthcare services anytime, anywhere',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colours.LightBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Colours.LightBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Colours.LightBlue,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Icon(
              icon,
              color: Colours.White,
              size: 24.w,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.lightBlue20blod.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  description,
                  style: TextStyles.gray15blod.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            config.localization['clincs'] ?? 'Our Clinics',
            style: TextStyles.lightBlue20blod.copyWith(
              fontSize: 22.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        const Clinics(),
      ],
    );
  }

  Widget _buildTestimonialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            config.localization['custmoerOpinion'] ?? 'What Our Patients Say',
            style: TextStyles.lightBlue20blod.copyWith(
              fontSize: 22.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        BlocProvider(
          create: (context) => OpinionsCubit()..getOpinions(),
          child: BlocConsumer<OpinionsCubit, OpinionsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return const OpinonBulider();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            config.localization['ourTeam'] ?? 'Our Medical Team',
            style: TextStyles.lightBlue20blod.copyWith(
              fontSize: 22.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        const TeamMembers(),
      ],
    );
  }

  Widget _buildCallToActionSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colours.LightBlue, Colours.DarkBlue],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.login,
            size: 40.w,
            color: Colours.White,
          ),
          SizedBox(height: 10.h),
          Text(
            'Ready to Get Started?',
            style: TextStyles.white20blod.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Join thousands of satisfied patients who trust My Clinic for their healthcare needs.',
            style: TextStyles.white20blod.copyWith(
              fontSize: 14.sp,
              color: Colours.White.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.eulaRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.White,
                    foregroundColor: Colours.DarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.loginRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colours.White,
                    side: BorderSide(color: Colours.White),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    config.localization['login'],
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
