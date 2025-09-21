import 'package:dr_sami/featurs/auth/login_first.dart';
import 'package:dr_sami/featurs/eula/eula.dart';
import 'package:dr_sami/featurs/home_screen/baners/add_banner.dart';
import 'package:dr_sami/featurs/auth/forget_password/change_password.dart';
import 'package:dr_sami/featurs/auth/forget_password/confirm_email.dart';
import 'package:dr_sami/featurs/auth/forget_password/otp.dart';
import 'package:dr_sami/featurs/auth/login/login.dart';
import 'package:dr_sami/featurs/auth/profile/profile.dart';
import 'package:dr_sami/featurs/home_screen/home_screen.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/all_request.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/requst_meet.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/user_requests.dart';
import 'package:dr_sami/featurs/onboarding/onboarding_screen.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';

import '../featurs/auth/profile/update_profil.dart';
import '../featurs/auth/register/register.dart';
import '../featurs/home_screen/opinions/create_opinion_form.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case Routes.intialRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case Routes.addBannedRoute:
        return MaterialPageRoute(builder: (_) => const AddBanner());
      case Routes.addOpinionRoute:
        return MaterialPageRoute(builder: (_) => const AddOpinion());
      case Routes.confirmEmail:
        return MaterialPageRoute(builder: (_) => ConfirmEmail());
      case Routes.confirmOTP:
        return MaterialPageRoute(builder: (_) => const Otp());
      case Routes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePassword());
      case Routes.requsetMeatRoute:
        return MaterialPageRoute(builder: (_) => const RequstMeet());
      case Routes.allRequestsMeetRoute:
        return MaterialPageRoute(builder: (_) => const AllReuests());
      case Routes.userRequestsMeetRoute:
        return MaterialPageRoute(builder: (_) => const UserRequests());
      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_) => const Profile());
      case Routes.updateProfileRoute:
        return MaterialPageRoute(builder: (_) => const UpdateProfile());
      case Routes.eulaRoute:
        return MaterialPageRoute(builder: (_) => const Eula());
      case Routes.loginFirstRoute:
        return MaterialPageRoute(builder: (_) => const LoginFirst());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Route Not Found'),
            ),
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
    }
  }
}
