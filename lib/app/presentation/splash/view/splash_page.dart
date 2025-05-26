import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/presentation/splash/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/splash/controller/state.dart';
import 'package:fakestore/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  Widget _buildBody(BuildContext context) => BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          final cubit = context.read<SplashCubit>();
          return state.maybeWhen(
            orElse: () => Center(
              child: CircularProgressIndicator(
                color: context.themeC.buttonBackground,
                strokeCap: StrokeCap.round,
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => BlocProvider<SplashCubit>(
        create: (context) => Injector.resolve<SplashCubit>()..init(),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: context.themeC.background,
            body: _buildBody(context),
          ),
        ),
      );
}
