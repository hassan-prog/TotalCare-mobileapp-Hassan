// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grad_login/providers/cartProvider.dart';
import 'package:grad_login/providers/wishProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../infrastructure/shared/storage.dart';
import '../widgets/error_dialog_box.dart';
import 'register_screen.dart';

import '../app_state.dart';
import '../providers/userProvider.dart';
import '../providers/authProvider.dart';
import '../widgets/input_field.dart';
import '../widgets/sign_button.dart';
import 'tabs_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var visible = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  Storage storage = Storage();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mainTopPadding = mediaQuery.size.height * 0.13;
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final appLocalization = AppLocalizations.of(context)!;
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    final cartProvider = Provider.of<Cart>(context);
    final wishProvider = Provider.of<Wish>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          key: key,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.only(
              top: mainTopPadding,
              left: mediaQuery.size.width * 0.05,
              right: mediaQuery.size.width * 0.05,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Total Care',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleLarge!
                          .copyWith(fontSize: mediaQuery.size.width * 0.095),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      appLocalization.signIn,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium!
                          .copyWith(fontSize: mediaQuery.size.width * 0.055),
                    ),
                  ),
                  InputField(
                    labelText: appLocalization.username,
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalization.usernameNotEmpty;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    obsecureText: false,
                  ),
                  InputField(
                    labelText: appLocalization.password,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      icon: visible
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                              size: 22,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: Colors.grey,
                              size: 22,
                            ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalization.passwordNotEmpty;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    obsecureText: visible,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade600,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            appLocalization.forgetPassword,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: mediaQuery.size.width * 0.033),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SignButton(
                    mediaQuery: mediaQuery,
                    onPressed: () => onPressed(authProvider, userProvider,
                        cartProvider, wishProvider, context),
                    label: appLocalization.login,
                  ),
                  if (authProvider.appState == AppState.loading)
                    CircularProgressIndicator.adaptive(),
                  Column(
                    children: [
                      Row(
                        children: [
                          CreateDivider(),
                          Text(
                            appLocalization.or,
                          ),
                          CreateDivider(),
                        ],
                      ),
                      SignWithGoogleButton(
                          mediaQuery: mediaQuery,
                          appLocalization: appLocalization),
                      Container(
                        padding: EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${appLocalization.dontHaveAnAccount} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      fontSize: mediaQuery.size.width * 0.038),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    RegisterFormScreen.routeName);
                                setState(() {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .isRegister = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade600,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  appLocalization.register,
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                          fontSize:
                                              mediaQuery.size.width * 0.038),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onPressed(
      authProvider, userProvider, cartProvider, wishProvider, context) async {
    if (_formKey.currentState!.validate()) {
      await authProvider
          .login(
              username: nameController.text, password: passwordController.text)
          .then((_) {
        if (authProvider.appState == AppState.error) {
          showAlertDialog(
              context: context,
              content: authProvider.errorMessage!,
              confirmButtonText: 'Dismiss',
              onConfirmPressed: () {
                Navigator.pop(context);
              },
              title: 'Oops something went wrong...');
          return;
        }
      }).then((_) async {
        if (authProvider.appState == AppState.done) {
          final token = await storage.getToken();

          List<String> parts = token!.split('.');
          String payload = parts[1];
          while (payload.length % 4 != 0) {
            payload += '=';
          }
          Map<String, dynamic> data =
              json.decode(utf8.decode(base64Url.decode(payload)));

          userProvider.jwtUserData = data;
          cartProvider.fetchCart();
          wishProvider.getWishID();
          userProvider
              .getUserMedications()
              .then((_) => Navigator.of(context).pushReplacementNamed(
                    TabsScreen.routeName,
                  ));
        }
      });
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class SignWithGoogleButton extends StatelessWidget {
  const SignWithGoogleButton({
    Key? key,
    required this.mediaQuery,
    required this.appLocalization,
  }) : super(key: key);

  final MediaQueryData mediaQuery;
  final AppLocalizations appLocalization;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('tap');
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        minimumSize: Size(
          mediaQuery.size.width * 0.85,
          mediaQuery.size.height * 0.06,
        ),
        side: BorderSide(
          width: 0.8,
          color: Colors.grey,
        ),
      ),
      child: SizedBox(
        width: mediaQuery.size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.png',
              height: 20,
              width: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              appLocalization.signInWithGoogle,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(fontSize: mediaQuery.size.width * 0.038),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateDivider extends StatelessWidget {
  const CreateDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Divider(
          color: Colors.black,
          height: 36,
        ),
      ),
    );
  }
}
