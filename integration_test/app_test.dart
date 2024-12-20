import 'package:flutter/foundation.dart';
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

    // Find widgets
    final Finder emailField = find.byKey(Key('emailFieldTestKey'));
    final Finder passwordField = find.byKey(Key('passwordFieldTestKey'));
    final Finder loginButton = find.byKey(Key('signInButtonTestKey'));
    final Finder signUpButtonInSignIn =
        find.byKey(Key('signUpButtonInSignInTestKey'));

    // Interact with widgets
    await tester.enterText(emailField, 'amrofficialacc@gmail.com');
    await tester.enterText(passwordField, '123456');
    await tester.pumpAndSettle(Duration(seconds: 3));

    await tester.tap(loginButton);
    // await tester.pumpAndSettle(Duration(seconds: 3));

    // await tester.tap(signUpButtonInSignIn);

    // Wait for animations and backend responses
    await tester.pumpAndSettle(Duration(seconds: 3));
    print("done till now");

    // Verify outcomes
    // expect(find.text('Home'), findsOneWidget);
  });
}
