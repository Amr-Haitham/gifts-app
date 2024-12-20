import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gifts_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('end-to-end test', (WidgetTester tester) async {
    // Start the app
    await app.main();
    await tester.pumpAndSettle(
      Duration(seconds: 5),
    );

// Go to friends find new user
// Click on new user
// Click on home
// Click on new user
// Click on Gift
// Click on Pledge this gift
    final Finder friendsIcon = find.byKey(Key("friendsButtonTestKey"));
    final Finder newUserText = find.text('new user');
    final Finder addFriend = find.text('Add Friend').first;
    final Finder firstEventCard = find.byKey(Key("EventCardTestKey")).first;
    final Finder homeIcon = find.byKey(Key("homeButtonTestKey"));
    final Finder logoutIcon = find.byKey(Key("logoutIcon"));

    await tester.tap(friendsIcon);
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(friendsIcon);
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(addFriend);

    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(homeIcon);


    await tester.pumpAndSettle(Duration(seconds: 4));
    await tester.tap(logoutIcon);
    await tester.pumpAndSettle(Duration(seconds: 3));

    expect(find.text('Login'), findsOneWidget);

    // Interact with widgetsf
    // await tester.enterText(emailField, 'amrofficialacc@gmail.com');
    // await tester.enterText(passwordField, '123456');
    // await tester.pumpAndSettle(Duration(seconds: 3));

    // await tester.tap(loginButton);
    // await tester.pumpAndSettle(Duration(seconds: 3));

    // await tester.tap(signUpButtonInSignIn);

    // Wait for animations and backend responses
    await tester.pumpAndSettle(Duration(seconds: 3));
    print("done till now");

    // Verify outcomes
    // expect(find.text('Home'), findsOneWidget);
  });
}
