import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/core/widgets/button_widget.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    required this.onTapNext,
    super.key,
  });

  final VoidCallback onTapNext;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.themeC.background,
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                R.introBg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Image.asset(
                  R.logo,
                  width: 58,
                  height: 58,
                ),
              ),
              SizedBox(height: 18),
              Text(
                context.t.appName,
                style: context.themeC.textStyle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 40),
              ButtonWidget(
                type: ButtonType.dark,
                label: context.t.login,
                onTap: onTapNext,
              ).paddingSymmetric(horizontal: 20),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
            ],
          ),
        ),
      );
}
