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

//       // default:
//       //   return MaterialPageRoute(builder: (context) => initialRoute);
//     }
//     return null;
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/controller/custom_users/get_custom_user_controller.dart';
import 'package:gifts_app/controller/custom_users/set_custom_user_controller.dart';
import 'package:gifts_app/controller/events/get_home_screen_events.dart';
import 'package:gifts_app/controller/pledges/get_custom_user_pledges_controller.dart';
import 'package:gifts_app/model/classes/custom_user.dart';
import 'package:gifts_app/model/sink/custom_user_sink.dart';
import 'package:gifts_app/model/sink/events_sink.dart';
import 'package:gifts_app/model/sink/friends_sink.dart';
import 'package:gifts_app/view/all_pledges_view.dart';
import '../../main.dart';
import '../controller/custom_users/get_custom_users_conroller.dart';
import '../controller/events/delete_event_controller.dart';
import '../controller/events/get_events_for_custom_user_conroller.dart';
import '../controller/events/set_event_controller.dart';
import '../controller/friends/add_remove_friend_conroller.dart';
import '../controller/friends/get_all_friends_controller.dart';
import '../controller/gifts/delete_gift_conroller.dart';
import '../controller/gifts/get_gifts_in_events_conroller.dart';
import '../controller/gifts/set_gift_controller.dart';
import '../controller/notifications/notification_cubit_controller.dart';
import '../controller/notifications/notificatoin_local_db_controller.dart';
import '../controller/pledges/get_pledge_status_controller.dart';
import '../model/classes/event.dart';
import '../model/sink/friendship_sink.dart';
import '../model/sink/gifts_sink.dart';
import '../model/sink/pledges_sink.dart';
import '../view/all_users_view.dart';
import '../view/authentication/presentation/manager/authentication_cubit/authentication_cubit.dart';
import '../view/authentication/presentation/manager/authentication_op/authentication_op_cubit.dart';
import '../view/authentication/presentation/pages/auth_wrapper.dart';
import '../view/authentication/presentation/pages/sign_in_screen.dart';
import '../view/authentication/presentation/pages/sign_up_screen.dart';
import '../view/events_views/enter_event_view.dart';
import '../view/events_views/my_events_view.dart';
import '../view/gift_views/enter_gift_view.dart';
import '../view/gift_views/gifts_view.dart';
import '../view/home_skeleton_view.dart';
import '../view/home_view.dart';
import '../view/notification_view.dart';
import '../view/profile_view.dart';

class Routes {
  static const String authWrapper = "/";
  static const String signUpRoute = 'sign_up_screen_route';
  // static const String profileScreenRoute = 'profile_screen_route';
  static const String giftsListScreenRoute = 'gifts_list_screen_route';
  static const String eventFormScreenRoute = 'event_form_screen_route';
  static const String myEventsScreenRoute = 'my_events_screen_route';
  static const String setGiftsScreenRoute = 'set_gifts_screen_route';
  static const String pledgedByMeScreenRoute = 'pledged_by_me_screen_route';
  static const String notificationsScreenRoute = 'notifications_screen_route';
  static const String allUsersScreenRoute = 'all_users_screen_route';
}

class AppRouter {
  final SetEventCubit _setEventCubit = SetEventCubit(
    SetEventUseCase(
      EventsSink(),
    ),
  );
  final SetGiftForEventCubit _setGiftForEventCubit = SetGiftForEventCubit(
    SetGiftForEventUseCase(
      GiftsSink(),
    ),
  );

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.authWrapper:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => AuthenticationCubit()),
                    BlocProvider(
                        create: (context) => NotificationCubit(
                            )),
                  ],
                  child: AuthWrapper(
                    homeScreen: HomeSkeletonView(
                      home: MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (context) => GetHomeScreenEvents(
                                    GetHomeScreenEventsUseCase(
                                      EventsSink(),
                                      FriendsSink(),
                                    ),
                                  )),
                          BlocProvider(
                              create: (context) => GetAppUserCubit(
                                    GetAppUserUseCase(),
                                  )),
                        ],
                        child: HomeScreen(),
                      ),
                      friends: MultiBlocProvider(
                        providers: [
                          BlocProvider(
                              create: (context) => GetAllUsersCubit(
                                    GetAllUsersUseCase(),
                                  )),
                          BlocProvider(
                              create: (context) => GetAllFriendsCubit(
                                    GetAllFriendsUseCase(
                                      FriendshipSink(),
                                    ),
                                  )),
                          BlocProvider(
                              create: (context) => FollowUnfollowCubit(
                                    FollowUnfollowUseCase(
                                      FriendshipSink(),
                                    ),
                                  )),
                        ],
                        child: AllUsersScreen(),
                      ),
                      profileDrawer: BlocProvider(
                          create: (context) => GetAppUserCubit(
                                GetAppUserUseCase(),
                              ),
                          child: ProfileScreen()),
                    ),
                    signInScreen: BlocProvider(
                        create: (context) => AuthenticationOpCubit(),
                        child: const SignInScreen()),
                  ),
                ));
      // case Routes.allUsersScreenRoute:
      //   return MaterialPageRoute(
      //       builder: (context) => );

      case Routes.notificationsScreenRoute:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => GetLocalNotificationsCubit(),
                    ),
                  ],
                  child: NotificationScreen(),
                ));
      case Routes.signUpRoute:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => AuthenticationOpCubit()),
                    BlocProvider(
                        create: (context) => SetCustomUserCubit(
                              SetCustomUserUseCase(
                                CustomUserSink(),
                              ),
                            )),
                  ],
                  child: const SignUpScreen(),
                ));

      case Routes.myEventsScreenRoute:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => GetUserEventsCubit(
                              GetUserEventsUseCase(
                                EventsSink(),
                              ),
                            )),
                    BlocProvider.value(value: _setEventCubit),
                    BlocProvider(
                        create: (context) => DeleteEventCubit(
                              DeleteEventUseCase(
                                EventsSink(),
                              ),
                            )),
                  ],
                  child: MyEventsScreen(),
                ));

      case Routes.eventFormScreenRoute:
        Event? event = settings.arguments as Event?;
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: _setEventCubit,
                  child: EventFormScreen(event: event),
                ));

      case Routes.giftsListScreenRoute:
        Event event = settings.arguments as Event;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => GetGiftsForEventCubit(
                              GetGiftsForEventUseCase(
                                GiftsSink(),
                              ),
                            )),
                    BlocProvider(
                        create: (context) =>
                            DeleteGiftForEventCubit(DeleteGiftForEventUseCase(
                              GiftsSink(),
                            ))),
                    BlocProvider.value(value: _setGiftForEventCubit),
                  ],
                  child: GiftsListScreen(
                      event: event,
                      isMyList: event.userId ==
                          FirebaseAuth.instance.currentUser!.uid),
                ));

      case Routes.setGiftsScreenRoute:
        Map mapWithGiftAndEventId = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: _setGiftForEventCubit),
                    BlocProvider(
                        create: (context) => GetPledgeStatusForGiftCubit(
                                GetPledgeStatusForGiftUseCase(
                              EventsSink(),
                              PledgesSink(),
                              GiftsSink(),
                              CustomUserSink(),
                            ))),
                    BlocProvider(
                        create: (context) =>
                            CommitmentCubit(CommitmentUseCase())),
                  ],
                  child: GiftFormScreen(
                    isMyGift: mapWithGiftAndEventId['isMyGift'] ?? true,
                    gift: mapWithGiftAndEventId['gift'],
                    eventId: mapWithGiftAndEventId['eventId'],
                  ),
                ));
      case Routes.pledgedByMeScreenRoute:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => UserPledgesCubit(UserPledgesUseCase()),
                child: PledgedByMeScreen()));
      // case Routes.notificationsScreenRoute:
      //   return MaterialPageRoute(builder: (context) => NotificationScreen());
    }
    return null;
  }
}
