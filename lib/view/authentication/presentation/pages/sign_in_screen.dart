import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/view/general_widgets_view/textfied.dart';

import '../../../../constants/app_router.dart';
import '../manager/authentication_op/authentication_op_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _signInFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AppLogo(
                        //   height: 60,
                        //   width: 60,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFieldWidget(
                        labelText: 'Email',
                        //S.of(context).email,
                        textController: emailController,
                        // validator: (value) => AuthInputValidator
                        //     .validateEmailAndReturnErrorMessage(value ?? ''),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFieldWidget(
                        labelText: 'Password',
                        //S.of(context).password,
                        isHiddenByDefault: true,
                        textController: passwordController,
                        // validator: (value) => AuthInputValidator
                        //     .validatePasswordAndReturnErrorMessage(value ?? ''),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height:
                      //if keyboard is open:
                      MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : ((Platform.isIOS == false) ? 195 : 125),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_signInFormKey.currentState?.validate() ?? false) {}
                        BlocProvider.of<AuthenticationOpCubit>(context)
                            .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) {
                          if (value) {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.authWrapper,
                                ModalRoute.withName(Routes.authWrapper));
                          }
                        });
                      },
                      child:Text( 'Login'),
                    ),
                    // const OrDivider(),
                    // (Platform.isIOS == false)
                    //     ? Container()
                    //     : const Padding(
                    //         padding: EdgeInsets.symmetric(vertical: 10),
                    //         child: ContinueWithAppleButton(),
                    //       ),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 10),
                    //   child: ContinueWithGoogleButton(),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.signUpRoute);
                            },
                            child: Text("Sign Up"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
