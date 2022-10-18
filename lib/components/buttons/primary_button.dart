import 'package:flutter/material.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.text,
      required this.onPressed})
      : super(key: key);
  final String text;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
                // side: const BorderSide(
                //     color: kTextButtonColor),
                borderRadius: BorderRadius.circular(
                    kDefaultBorderRadius))),
        onPressed: () =>
            onPressed != null ? onPressed!.call() : null,
        child: Text(
          text,
          style: kBody3.copyWith(color: kTextColor),
        ),
      ),
    );
  }
}
