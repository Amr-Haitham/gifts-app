import 'dart:ui';

import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/constants/utils.dart';
import 'package:gifts_app/controller/custom_users/set_custom_user_controller.dart';
import 'package:gifts_app/model/classes/custom_user.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

import '../../../../constants/app_router.dart';
import '../../auth_utility_functions/auth_utility_functions.dart';
import '../../auth_utility_functions/firebase_auth_services.dart';
import '../../domain/entities/password_checker.dart';
import '../../domain/sample_static_data.dart';
import '../manager/authentication_op/authentication_op_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String phoneNumber = '';
  String? selectedCountry;

  bool passwordIsValid = false;
  bool passwordMatch = false;
  bool emailIsValid = false;
  ValueNotifier<String> passwordNotifier = ValueNotifier<String>("");
  bool submitButtonPressed = false;
  List<String> countryNames = [];

  @override
  void initState() {
    countryNames = sampleCountries.map((country) => country.name).toList();

    passwordController.addListener(() {
      passwordNotifier.value = passwordController.text;
    });

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    countryController.dispose();
    phoneNumberController.dispose();
    passwordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<SetCustomUserCubit, SetCustomUserState>(
          listener: (context, state) {
            if (state is SetCustomUserLoaded) {
              Navigator.pushNamedAndRemoveUntil(context, Routes.authWrapper,
                  ModalRoute.withName(Routes.authWrapper));
            } else if (state is SetCustomUserError) {
              showErrorSnackBar(context, "Error adding user");
            }
          },
        ),
        BlocListener<AuthenticationOpCubit, AuthenticationOpState>(
          listener: (context, state) {
            if (state is AuthenticationOpLoaded) {
              BlocProvider.of<SetCustomUserCubit>(context).setCustomUser(
                CustomUser(
                  imageUrl: randomAssetImageLink(),
                  id: state.userCredential.user!.uid,
                  joinDate: DateTime.now(),
                  name: nameController.text,
                  email: state.userCredential.user!.email!,
                  phoneNumber: phoneNumber,
                  fcmToken: null,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Create account",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter your full name',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) => (value != null && value.contains('@'))
                        ? null
                        : 'Invalid email',
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: Icon(Icons.remove_red_eye),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_signUpFormKey.currentState?.validate() ?? false) {
                        await handleSignUpRequest(context);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.authWrapper);
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> handleSignUpRequest(BuildContext context) async {
    setState(() {
      submitButtonPressed = true;
    });

    // if (!emailIsValid) {
    //   showErrorSnackBar(context, "Email is invalid");
    // } else if (!passwordIsValid) {
    //   showErrorSnackBar(context, "Password is invalid");
    // } else {
    BlocProvider.of<AuthenticationOpCubit>(context)
        .createAccountWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    // }
    return null;
  }
}
