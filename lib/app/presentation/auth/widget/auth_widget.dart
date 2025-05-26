import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/resources/resource.dart';
import 'package:fakestore/app/core/widgets/button_widget.dart';
import 'package:fakestore/app/core/widgets/text_form_field.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({
    required this.onTapBack,
    required this.onTapLogin,
    required this.loading,
    super.key,
  });

  final VoidCallback onTapBack;
  final void Function(String, String) onTapLogin;
  final bool loading;

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;

  String? nonEmptyFieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.t.fieldRequired;
    }
    return null;
  }

  void onTapLogin() {
    final isValid = formKey.currentState!.validate();
    if (!isValid || isLoading) {
      return;
    }
    formKey.currentState!.save();
    final username = usernameController.text;
    final password = passwordController.text;
    widget.onTapLogin(username, password);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.themeC.background,
        body: IgnorePointer(
          ignoring: isLoading,
          child: Stack(
            children: [
              SafeArea(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: widget.onTapBack,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 42,
                            height: 42,
                            margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.themeC.divider),
                            ),
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              R.backArrowIcon,
                              colorFilter: ColorFilter.mode(
                                context.themeC.textPrimary,
                                BlendMode.srcIn,
                              ),
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            SizedBox(height: 20),
                            Text(
                              context.t.welcomeText,
                              style: context.themeC.textStyle.copyWith(
                                color: context.themeC.textPrimary,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 32),
                            CustomTextFormField(
                              validator: nonEmptyFieldValidator,
                              controller: usernameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              hintText: context.t.usernameHint,
                            ),
                            SizedBox(height: 16),
                            CustomTextFormField(
                              obscureText: obscureText,
                              onTapSuffix: () {
                                setState(() => obscureText = !obscureText);
                              },
                              validator: nonEmptyFieldValidator,
                              controller: passwordController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              hintText: context.t.passwordHint,
                            ),
                            SizedBox(height: 30),
                            ButtonWidget(
                              type: ButtonType.dark,
                              label: context.t.login,
                              onTap: onTapLogin,
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.loading)
                Positioned.fill(
                  child: ColoredBox(
                    color: context.themeC.background.withValues(alpha: 0.2),
                  ),
                ),
              if (widget.loading)
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.themeC.buttonBackground,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
