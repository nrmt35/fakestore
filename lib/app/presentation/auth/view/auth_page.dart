import 'package:fakestore/app/presentation/auth/controller/cubit_controller.dart';
import 'package:fakestore/app/presentation/auth/controller/state.dart';
import 'package:fakestore/app/presentation/auth/widget/auth_widget.dart';
import 'package:fakestore/app/presentation/auth/widget/intro_widget.dart';
import 'package:fakestore/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Widget _buildBody(BuildContext context) => BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          return state.maybeWhen(
            intro: () => IntroWidget(
              onTapNext: cubit.onTapNext,
            ),
            orElse: () => AuthWidget(
              loading: cubit.isLoading,
              onTapLogin: cubit.onTapLogin,
              onTapBack: cubit.onTapBack,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => BlocProvider<AuthCubit>(
      create: (context) => Injector.resolve<AuthCubit>()..init(), child: _buildBody(context));
}
