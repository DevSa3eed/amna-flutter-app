import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/all_pending_requests.dart';
import 'package:flutter/material.dart';

import '../../../core/config/config.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import 'aprroved_notpay.dart';
import 'paied_approved.dart';

class AllReuests extends StatelessWidget {
  const AllReuests({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: Colours.White,
        appBar: AppBar(
          title: Text(
            config.localization['requestMeeting'],
            style: TextStyles.lightBlue20blod,
          ),
          bottom: TabBar(
            indicatorColor: Colours.DarkBlue,
            labelStyle:
                TextStyle(color: Colours.DarkBlue, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(icon: Icon(Icons.pending_sharp), text: "Pending"),
              Tab(icon: Icon(Icons.payments_rounded), text: "Not paid"),
              Tab(icon: Icon(Icons.check), text: "Paid"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PendingRequst(),
            AprrovedNotPayRequst(),
            AprrovedRequst(),
          ],
        ),
      ),
    );
  }
}
