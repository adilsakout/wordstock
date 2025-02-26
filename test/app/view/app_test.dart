import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/app/app.dart';
import 'package:wordstock/onboarding/view/onboarding_page.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OnboardingPage), findsOneWidget);
    });
  });
}
