// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/authentication_cubit/authentication_cubit.dart';

class AuthWrapper extends StatefulWidget {
  final Widget homeScreen;
  final Widget signInScreen;

  const AuthWrapper({
    super.key,
    required this.homeScreen,
    required this.signInScreen
  });
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    BlocProvider.of<AuthenticationCubit>(context).startAuthenticationStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return widget.homeScreen;
        }
        //will use it if we want to show onboarding screen in certain times
        // else if (state is UnAuthenticated) {
        //   // if (!(state.appIsStarting)) {
        //   //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //   //     Navigator.pushNamedAndRemoveUntil(context, signInScreenUrl,
        //   //         ModalRoute.withName(authWrapperUrl));
        //   //   });

        //   //   return const Scaffold(body: SizedBox());
        //   // }
        //   // return const SplashFirstTransitionScreen();
        // }
        else {
          //           WidgetsBinding.instance.addPostFrameCallback((_) {
          //   Navigator.pushNamedAndRemoveUntil(context, Routes.authWrapper,
          //       ModalRoute.withName(Routes.authWrapper));
          // });

          return widget.signInScreen;
        }
      },
    );
  }
}
