import 'package:flutter/material.dart';
import 'package:grad_login/providers/interactionsProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/tabs_screen.dart';
import 'screens/show_interactions_results_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/sign_screen.dart';
import 'providers/medicineProvider.dart';
import 'providers/userProvider.dart';
import 'providers/authProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: MedicineProvider(),
        ),
        ChangeNotifierProvider.value(
          value: InteractionsProvider(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'first demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(197, 238, 255, 255),
            secondary: const Color.fromRGBO(167, 252, 132, 0.7),
          ),
        ),
        home: const LoginScreen(),
        routes: {
          SignInScreen.routeName: (ctx) => const SignInScreen(),
          ShowInteractionsResultsScreen.routeName: (ctx) =>
              const ShowInteractionsResultsScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          RegisterFormScreen.routeName: (ctx) => const RegisterFormScreen(),
          TabsScreen.routeName: (ctx) => const TabsScreen(),
        },
      ),
    );
  }
}
