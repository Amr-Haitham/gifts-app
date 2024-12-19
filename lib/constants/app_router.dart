// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Routes {
//   // static const String rootRoute = '/';
//   static const String authWrapper = "/";
//   // static const String onboardingRoute = 'onboarding_screen_route';
//   // static const String signInRoute = 'sign_in_screen_route';
//   static const String signUpRoute = 'sign_up_screen_route';
//   static const String profileScreenRoute = 'profile_screen_route';
//   static const String giftsListScreenRoute = 'gifts_list_screen_route';
//   static const String eventFormScreenRoute = 'event_form_screen_route';
//   static const String myEventsScreenRoute = 'my_events_screen_route';
//   static const String setGiftsScreenRoute = 'set_gifts_screen_route';
//   static const String pledgedByMeScreenRoute = 'pledged_by_me_screen_route';
//   static const String notificationsScreenRoute = 'notificaitons_screen_route';
//   static const String allUsersScreenRoute = 'all_users_screen_route';
// }

// class AppRouter {
//   //AppRouter._();

//   final SetEventCubit _setEventCubit = SetEventCubit();
//   final SetGiftForEventCubit _setGiftForEventCubit = SetGiftForEventCubit();
//   // final DeleteEventCubit _deleteEventCubit = DeleteEventCubit();
//   // Widget initialRoute = const OnboardingScreen();
//   // //
//   // void setInitialRouteToLandingScreen() {
//   //   initialRoute = const OnboardingScreen();
//   // }

//   // void setInitialRouteToHome() {
//   //   initialRoute =  HomeScreen(setBillBoardCubit: _setBillBoardCubit, mainScreens: [],);
//   // }
//   // final SetBillBoardCubit _setBillBoardCubit = SetBillBoardCubit();
//   // final DeleteBillBoardCubit _deleteBillBoardCubit = DeleteBillBoardCubit();

//   Route? generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       // case '/':
//       //   return MaterialPageRoute(builder: (context) =>  AuthUtilityFunctions.authenticationGateRouter());

//       // case Routes.onboardingRoute:
//       //   return MaterialPageRoute(
//       //       builder: (context) => const OnboardingScreen());
//       case Routes.authWrapper:
//         return MaterialPageRoute(
//             builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                       create: (context) => AuthenticationCubit(),
//                     ),
//                   ],
//                   child: BlocProvider(
//                     create: (context) => NotificationCubit(
//                         FirebaseAuth.instance.currentUser!.uid),
//                     child: AuthWrapper(
//                       homeScreen: MultiBlocProvider(
//                         providers: [
//                           BlocProvider(
//                             create: (context) =>
//                                 GetLatestEventsForFriendsCubit(),
//                           ),
//                           BlocProvider(
//                             create: (context) => GetSingleAppuserCubit(),
//                           ),
//                         ],
//                         child: HomeScreen(),
//                       ),
//                       signInScreen: BlocProvider(
//                         create: (context) => AuthenticationOpCubit(),
//                         child: const SignInScreen(),
//                       ),
//                     ),
//                   ),
//                 ));
//       case Routes.allUsersScreenRoute:
//         return MaterialPageRoute(
//             builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                       create: (context) => GetAllUsersCubit(),
//                     ),
//                     BlocProvider(
//                       create: (context) => GetAllFriendsCubit(),
//                     ),
//                     BlocProvider(
//                       create: (context) => FollowUnfollowCubit(),
//                     ),
//                   ],
//                   child: AllUsersScreen(),
//                 ));

//       case Routes.signUpRoute:
//         return MaterialPageRoute(
//             builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                       create: (context) => AuthenticationOpCubit(),
//                     ),
//                     BlocProvider(
//                       create: (context) => SetCustomUserCubit(),
//                     ),
//                   ],
//                   child: const SignUpScreen(),
//                 ));

//       case Routes.profileScreenRoute:
//         return MaterialPageRoute(
//             builder: (context) => BlocProvider(
//                   create: (context) => GetSingleAppuserCubit(),
//                   child: ProfileScreen(),
//                 ));
//       case Routes.myEventsScreenRoute:
//         return MaterialPageRoute(
//             builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                       create: (context) => GetUserEventsCubit(),
//                     ),
//                     BlocProvider.value(
//                       value: _setEventCubit,
//                     ),
//                     BlocProvider(
//                       create: (context) => DeleteEventCubit(),
//                     ),
//                   ],
//                   child: MyEventsScreen(),
//                 ));

//       case Routes.eventFormScreenRoute:
//         Event? event = settings.arguments as Event?;
//         return MaterialPageRoute(
//             builder: (context) => BlocProvider.value(
//                   value: _setEventCubit,
//                   child: EventFormScreen(
//                     event: event,
//                   ),
//                 ));

//       case Routes.giftsListScreenRoute:
//         Event event = settings.arguments as Event;
//         return MaterialPageRoute(
//             builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider(
//                       create: (context) => GetGiftsForEventCubit(),
//                     ),
//                     BlocProvider(
//                       create: (context) => DeleteGiftForEventCubit(),
//                     ),
//                     BlocProvider.value(
//                       value: _setGiftForEventCubit,
//                     ),
//                   ],
//                   child: GiftsListScreen(
//                     event: event,
//                     isMyList: event.userId == AuthUtils.getCurrentUserUid(),
//                   ),
//                 ));

//       case Routes.setGiftsScreenRoute:
//         Map mapWithGiftAndEventId = settings.arguments as Map;

//         return MaterialPageRoute(
//             builder: (context) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider.value(
//                       value: _setGiftForEventCubit,
//                     ),
//                     BlocProvider(
//                       create: (context) => GetPledgeStatusForGiftCubit(),
//                     ),
//                     BlocProvider(
//                       create: (context) => AddPledgeCubit(),
//                     ),
//                   ],
//                   child: GiftFormScreen(
//                     isMyGift: mapWithGiftAndEventId['isMyGift'] ?? true,
//                     gift: mapWithGiftAndEventId['gift'],
//                     eventId: mapWithGiftAndEventId['eventId'],
//                   ),
//                 ));
//       case Routes.pledgedByMeScreenRoute:
//         return MaterialPageRoute(
//             builder: (context) => BlocProvider(
//                   create: (context) => GetMyPledgesCubit(),
//                   child: PledgedByMeScreen(),
//                 ));
//       case Routes.notificationsScreenRoute:
//         return MaterialPageRoute(builder: (context) => NotificationScreen());

//       // default:
//       //   return MaterialPageRoute(builder: (context) => initialRoute);
//     }
//     return null;
//   }
// }
