import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/cubit/meeting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showAlertWithTextField(int id, String phone, BuildContext context) {
  final TextEditingController textController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => MeetingCubit(),
        child: BlocConsumer<MeetingCubit, MeetingState>(
          listener: (context, state) {
            if (state is UpdateRequestStatusPaymentSuccess) {
              context.read<MeetingCubit>().getAllRequsetForAdmin();
            }
          },
          builder: (context, state) {
            return AlertDialog(
              backgroundColor: Colours.White,
              title: const Text("Cost of Consultaion"),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Cost of Consultaion",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Handle Cancel
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Handle OK
                    String userInput = textController.text;
                    context.read<MeetingCubit>().approveRequest(
                        id: id,
                        price: double.parse(userInput) * inDollar!,
                        phone: phone);
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
