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
import '../../../general_widgets_view/textfied.dart';
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
  final TextEditingController phoneNumberController =
      TextEditingController(); //do not use this controller value when submitting, it doesn't have the country code
  String phoneNumber =
      ''; //When submitting, use this variable, not the phoneNumberController, because the controller doesn't have the country code

  String? selectedCountry;

  bool passwordIsValid = false;
  bool passwordMatch = false;
  bool emailIsValid = false;
  ValueNotifier<String> passwordNotifier =
      ValueNotifier<String>(""); //value notifier for password updates

  bool submitButtonPressed = false;

  List<String> countryNames = [];

  // void updatePasswordCheckers() {
  //   setState(() {
  //     passwordIsValid =
  //         AuthInputValidator.validatePassword(passwordController.text);
  //   });
  // }

  @override
  void initState() {
    countryNames = sampleCountries.map((country) => country.name).toList();

    passwordController.addListener(() {
      passwordNotifier.value = passwordController.text;

      // updatePasswordCheckers();
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
    return MultiBlocListener(
      listeners: [
        BlocListener<SetCustomUserCubit, SetCustomUserState>(
          listener: (context, state) {
            if (state is SetCustomUserLoaded) {
              Navigator.pushNamedAndRemoveUntil(context, Routes.authWrapper,
                  ModalRoute.withName(Routes.authWrapper));
            } else if (state is SetCustomUserLoading ||
                state is SetCustomUserInitial) {
              showErrorSnackBar(context, "Adding user");
            } else {
              showErrorSnackBar(context, "Error adding user");
            }
          },
        ),
        BlocListener<AuthenticationOpCubit, AuthenticationOpState>(
          listener: (context, state) {
            if (state is AuthenticationOpLoaded) {
              BlocProvider.of<SetCustomUserCubit>(context).setCustomUser(
                  CustomUser(
                      imageUrl: "adsfa",
                      id: state.userCredential.user!.uid,
                      joinDate: DateTime.now(),
                      name: nameController.text,
                      email: state.userCredential.user!.email!,
                      phoneNumber: phoneNumber,
                      fcmToken: null));

              //Raslan moved nvigator here to navigate only when adding user
            } else if (state is SetCustomUserError) {
              //Raslan error handling for error in adding user
            } else {
              //Raslan loading handling
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _signUpFormKey,
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
                        children: [],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Create account",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
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
                          labelText: 'Enter your full name',
                          textController: nameController,
                          validator: (value) => (nameController.text.isEmpty)
                              ? 'Please enter your name'
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFieldWidget(
                          labelText: 'Enter your email',
                          //S.of(context).email,
                          textController: emailController,
                          // validator: (value) =>
                          //     AuthInputValidator.validateEmail(
                          //             emailController.text)
                          //         ? null
                          //         : 'invalid email',
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8),
                      //   child: phoneNumberWidget(),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFieldWidget(
                          labelText: 'password',
                          isHiddenByDefault: true,
                          textController: passwordController,
                          suffix: const Icon(
                            Icons.remove_red_eye,
                          ),
                          onChanged: (value) {
                            setState(() {
                              // validatePassword(passwordController.text);
                            });
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8),
                      //   child: listOfPasswordCheckers(),
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_signUpFormKey.currentState?.validate() ??
                              false) {}

                          // AuthUtilityFunctions.validatePassword(passwordController.text);
                          await handleSignUpRequest(context);
                          // signUp(email: emailController.text, password: passwordController.text, context: context);
                        },
                        child: Text('Sign Up'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: signInInsteadButton(context, () {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.authWrapper);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
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

  Widget signInInsteadButton(BuildContext context, Function() onTap) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        ElevatedButton(child: Text("Login"), onPressed: onTap),
      ],
    );
  }

  Future<User?> handleSignUpRequest(BuildContext context) async {
    setState(() {
      submitButtonPressed = true;
      passwordIsValid = true;
      emailIsValid = true;
    });
    if (!emailIsValid) {
      showErrorSnackBar(context, "Email is invalid");
    } else if (!passwordIsValid) {
      showErrorSnackBar(context, "Password is invalid");
    } else {
      BlocProvider.of<AuthenticationOpCubit>(context)
          .createAccountWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    }
    return null;
  }

  Widget phoneNumberWidget() {
    return InternationalPhoneNumberInput(
      height: 60,
      controller: phoneNumberController,
      inputFormatters: const [],
      formatter: MaskedInputFormatter('##########'),
      initCountry:
          CountryCodeModel(name: "Egypt", dial_code: "+20", code: "EG"),
      betweenPadding: 23,
      onInputChanged: (phone) {
        phoneNumber = "${phone.dial_code}${phone.rawNumber}";
      },
      dialogConfig: DialogConfig(
        backgroundColor: Colors.white,
        searchBoxBackgroundColor: Colors.grey,
        searchBoxIconColor: Colors.black,
        countryItemHeight: 55,
        topBarColor: Colors.black,
        selectedItemColor: Colors.grey,
        selectedIcon: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            "assets/check.png",
            width: 20,
            fit: BoxFit.fitWidth,
          ),
        ),
        textStyle: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
        searchBoxTextStyle: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
        titleStyle: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        searchBoxHintStyle: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      countryConfig: CountryConfig(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          noFlag: false,
          textStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
      phoneConfig: PhoneConfig(
        focusedColor: Colors.black,
        enabledColor: Colors.grey,

        focusNode: null,
        radius: 12,
        hintText: "Phone Number",
        borderWidth: 1,
        backgroundColor: Colors.transparent,
        decoration: null,
        //  popUpErrorText: true,
        autoFocus: false,
        showCursor: true,
        hintStyle: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}
