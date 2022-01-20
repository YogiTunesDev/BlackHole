import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/Helpers/backup_restore.dart';
import 'package:blackhole/Helpers/config.dart';
import 'package:blackhole/Helpers/supabase.dart';
import 'package:blackhole/Screens/splash_screen.dart';
import 'package:blackhole/model/signup_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen();
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isNewsLetterChecked = false;
  String? errorMessage;
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TextButton(
                  //       onPressed: () async {
                  //         Navigator.popAndPushNamed(context, '/login');
                  //       },
                  //       child: const Text(
                  //         'login',
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                                    text: 'Welcome!',
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
                                    "\nGet started with our free 30 days trial by entering your name and a password below.\n\n",
                                style: TextStyle(
                                  // height: 0.97,
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                //
                              ),
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
                                      bottom: 10,
                                    ),
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
                                      controller: nameController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Enter your name',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //     top: 5,
                                  //     bottom: 5,
                                  //     left: 10,
                                  //     right: 10,
                                  //   ),
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10.0),
                                  //     color: Colors.grey[900],
                                  //     boxShadow: const [
                                  //       BoxShadow(
                                  //         color: Colors.black26,
                                  //         blurRadius: 5.0,
                                  //         offset: Offset(0.0, 3.0),
                                  //       )
                                  //     ],
                                  //   ),
                                  //   child: TextFormField(
                                  //     controller: emailController,
                                  //     textAlignVertical:
                                  //         TextAlignVertical.center,
                                  //     keyboardType: TextInputType.emailAddress,
                                  //     decoration: InputDecoration(
                                  //       focusedBorder:
                                  //           const UnderlineInputBorder(
                                  //         borderSide: BorderSide(
                                  //           width: 1.5,
                                  //           color: Colors.transparent,
                                  //         ),
                                  //       ),
                                  //       prefixIcon: Icon(
                                  //         Icons.mail,
                                  //         color: Theme.of(context)
                                  //             .colorScheme
                                  //             .secondary,
                                  //       ),
                                  //       border: InputBorder.none,
                                  //       hintText: "Enter Your Email",
                                  //       hintStyle: const TextStyle(
                                  //         color: Colors.white60,
                                  //       ),
                                  //     ),
                                  //     validator: (value) {
                                  //       final RegExp emailRegex = RegExp(
                                  //           r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                                  //       if (value!.isEmpty) {
                                  //         return 'Please enter valid email';
                                  //       } else if (!emailRegex
                                  //           .hasMatch(value)) {
                                  //         return 'Please enter valid email';
                                  //       }
                                  //       return null;
                                  //     },
                                  //   ),
                                  // ),
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
                                      controller: passwordController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.text,
                                      obscureText: isObscure,
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
                                        hintText: "Enter Your Password",
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter valid password';
                                        } else if (value.length < 8) {
                                          return 'Paswword must be 8 digit';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        value: isNewsLetterChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isNewsLetterChecked = value!;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Get monthly updates on the newest music and hottest playlists',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\n\nBy signing up, you are agreeing to our Terms of service\n',
                                    style: TextStyle(
                                      color: Colors.grey.withOpacity(0.7),
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

                                  if (isLoading)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  else
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isLoading = true;
                                          errorMessage = null;
                                        });

                                        final bool valid =
                                            formKey.currentState!.validate();
                                        if (valid) {
                                          final SignupResponse? signupResponse =
                                              await YogitunesAPI().signup(
                                            nameController.text,
                                            args['email'].toString(),
                                            passwordController.text,
                                            isNewsLetterChecked,
                                          );
                                          if (signupResponse != null) {
                                            if (signupResponse.status!) {
                                              redirectAfterAuthentication(
                                                  context);
                                            } else {
                                              errorMessage = signupResponse.data
                                                  .toString();
                                            }
                                          } else {
                                            errorMessage = 'Server down!!!';
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
                                          child: isLoading
                                              ? CircularProgressIndicator()
                                              : Text(
                                                  'Take me to the music!',
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          text:
                                              'If you are sure you have already created an account,',
                                          style: TextStyle(
                                            color: Colors.grey.withOpacity(0.7),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  ' try another email address.',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          ],
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
