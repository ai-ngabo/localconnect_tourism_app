// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:community_touring_rwanda/main.dart';
import 'package:community_touring_rwanda/utils/app_constants.dart';
import 'package:community_touring_rwanda/models/user_model.dart';

void main() {
  testWidgets('registration and booking labels', (WidgetTester tester) async {
    await tester.pumpWidget(const CommunityTouringRwandaApp());

    // splash screen displayed
    expect(find.text(AppStrings.getStarted), findsOneWidget);

    // tap get started and navigate to signup
    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();

    // fill signup form
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.signUp));
    await tester.pumpAndSettle();

    // confirm home and search
    expect(find.text(AppStrings.popularTours), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Mountain');
    await tester.pumpAndSettle();
    expect(find.text('Mountain Hiking'), findsOneWidget);

    // open tour and book
    await tester.tap(find.text('Mountain Hiking'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.bookNow));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.numberOfGuests), findsOneWidget);
    expect(find.text(AppStrings.totalCost), findsOneWidget);
  });

  testWidgets('registration and profile menus', (WidgetTester tester) async {
    // ensure fresh session
    UserSession.logout();
    await tester.pumpWidget(const CommunityTouringRwandaApp());

    // signup again for a fresh session
    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'test2@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.signUp));
    await tester.pumpAndSettle();

    // open profile
    await tester.tap(find.byType(CircleAvatar).first);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.profile), findsOneWidget);

    // edit profile
    await tester.tap(find.text(AppStrings.editProfile));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'New Name');
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    expect(find.text('New Name'), findsOneWidget);

    // favorites/settings/support navigation
    await tester.scrollUntilVisible(find.text(AppStrings.favorites), 500);
    await tester.tap(find.text(AppStrings.favorites));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.favoritesComingSoon), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text(AppStrings.settingsLabel), 500);
    await tester.tap(find.text(AppStrings.settingsLabel));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.settingsComingSoon), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text(AppStrings.supportFaq), 500);
    await tester.tap(find.text(AppStrings.supportFaq));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.supportComingSoon), findsOneWidget);
  });
}
