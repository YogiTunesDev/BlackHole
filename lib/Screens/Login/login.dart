import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/Helpers/backup_restore.dart';
import 'package:blackhole/Helpers/config.dart';
import 'package:blackhole/Helpers/supabase.dart';
import 'package:blackhole/model/forgot_password_response.dart';
import 'package:blackhole/model/login_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uuid uuid = const Uuid();
  bool isLoading = false;
  bool isObscure = true;
  String? errorMessage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool forgotLoader = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future _addUserData(String name) async {
    int? status;
    await Hive.box('settings').put('name', name.trim());
    final DateTime now = DateTime.now();
    final List createDate = now
        .toUtc()
        .add(const Duration(hours: 5, minutes: 30))
        .toString()
        .split('.')
      ..removeLast()
      ..join('.');

    String userId = uuid.v1();
    status = await SupaBase().createUser({
      'id': userId,
      'name': name,
      'accountCreatedOn': '${createDate[0]} IST',
      'timeZone':
          "Zone: ${now.timeZoneName} Offset: ${now.timeZoneOffset.toString().replaceAll('.000000', '')}",
    });

    while (status == null || status == 409) {
      userId = uuid.v1();
      status = await SupaBase().createUser({
        'id': userId,
        'name': name,
        'accountCreatedOn': '${createDate[0]} IST',
        'timeZone':
            "Zone: ${now.timeZoneName} Offset: ${now.timeZoneOffset.toString().replaceAll('.000000', '')}",
      });
    }
    await Hive.box('settings').put('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return GradientContainer(
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 1.85,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage(
                      'assets/icon_white_trans_new.png',
                    ),
                  ),
                ),
              ),
              const GradientContainer(
                child: null,
                opacity: true,
              ),
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Welcome back!',
                                    style: TextStyle(
                                      height: 0.97,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                    '\nPlease take a moment to confirm it\'s you, and we will get you on your way.',
                                style: TextStyle(
                                  // height: 0.97,
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                //
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 10,
                                      right: 10,
                                    ),
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    // height: 57.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.grey[100],
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      obscureText: isObscure,
                                      controller: passwordController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isObscure = !isObscure;
                                            });
                                          },
                                          child: Icon(
                                            isObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Enter Your Password',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      // onSubmitted: (String value) async {
                                      //   if (value.trim() == '') {
                                      //     await _addUserData(
                                      //       AppLocalizations.of(context)!.guest,
                                      //     );
                                      //   } else {
                                      //     await _addUserData(value.trim());
                                      //   }
                                      //   Navigator.popAndPushNamed(
                                      //     context,
                                      //     '/pref',
                                      //   );
                                      // },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter valid password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (errorMessage != null)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          errorMessage!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (forgotLoader)
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      else
                                        TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              forgotLoader = true;
                                            });
                                            final ForgotPasswordResponse?
                                                forgotPasswordResponse =
                                                await YogitunesAPI()
                                                    .forgotPassword(
                                              args['email'].toString(),
                                            );

                                            if (forgotPasswordResponse !=
                                                null) {
                                              if (forgotPasswordResponse
                                                  .status!) {
                                                Navigator.pushNamed(context,
                                                    '/forgotPasswordVerification',
                                                    arguments: {
                                                      'email': args['email']
                                                          .toString(),
                                                    });
                                              } else {
                                                // errorMessage =
                                                //     forgotPasswordResponse.data
                                                //         .toString();
                                              }
                                            } else {
                                              // errorMessage = 'Server Down!!!';
                                            }
                                            setState(() {
                                              forgotLoader = false;
                                            });
                                          },
                                          child: const Text(
                                            'Forgot Password',
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (isLoading)
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  else
                                    GestureDetector(
                                      onTap: () async {
                                        errorMessage = null;
                                        setState(() {
                                          isLoading = true;
                                        });

                                        final bool valid =
                                            formKey.currentState!.validate();
                                        if (valid) {
                                          final LoginResponse? loginResponse =
                                              await YogitunesAPI().login(
                                            args['email'].toString(),
                                            passwordController.text,
                                          );

                                          if (loginResponse != null) {
                                            if (loginResponse.status!) {
                                              redirectAfterAuthentication(
                                                  context);
                                              // Navigator.pushNamed(
                                              //     context, '/home');
                                            } else {
                                              errorMessage =
                                                  loginResponse.data.toString();

                                              // setState(() {});
                                            }
                                          } else {
                                            errorMessage = 'Server Down!!!';
                                            // setState(() {});
                                          }
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        height: 55.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5.0,
                                              offset: Offset(0.0, 3.0),
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
