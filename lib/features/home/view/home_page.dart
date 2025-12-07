import 'package:flutter/material.dart';
import 'package:wordstock/features/home/widgets/home_body.dart';

/// {@template home_page}
/// A description for HomePage
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  /// The static route for HomePage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());
  }

  static const name = '/home';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // floatingActionButton: Platform.isIOS && kDebugMode
      //     ? FloatingActionButton(
      //         onPressed: () async {
      //           /// clear the IOS user defaults for the widget
      //           await HomeWidget.saveWidgetData<String>('word', null);
      //           await HomeWidget.saveWidgetData<String>('definition', null);
      //           await HomeWidget.saveWidgetData<String>('phonetic', null);
      //           await HomeWidget.saveWidgetData<String>('example', null);
      //           await HomeWidget.saveWidgetData<String>('isFavorite', null);

      //           await HomeWidget.updateWidget(
      //             iOSName: 'HomeWidget',
      //             androidName: 'HomeWidget',
      //           );

      //           if (context.mounted) {
      //             ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(
      //                 content:
      //                     Text('Widget data cleared!
      // Check your homescreen.'),
      //               ),
      //             );
      //           }
      //         },
      //         child: const Icon(Icons.delete_outline),
      //       )
      //     : null,
      body: HomeView(),
    );
  }
}

/// {@template home_view}
/// Displays the Body of HomeView
/// {@endtemplate}
class HomeView extends StatefulWidget {
  /// {@macro home_view}
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const HomeBody();
  }
}
