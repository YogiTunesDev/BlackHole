import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/model/forgot_password_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen();
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
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
                                  text: const TextSpan(
                                    text: 'Forgot Password',
                                    style: TextStyle(
                                      height: 0.97,
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    // children: <TextSpan>[
                                    //   const TextSpan(
                                    //     text: 'Music',
                                    //     style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 80,
                                    //       color: Colors.white,
                                    //     ),
                                    //   ),
                                    //   TextSpan(
                                    //     text: '.',
                                    //     style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 80,
                                    //       color: Theme.of(context)
                                    //           .colorScheme
                                    //           .secondary,
                                    //     ),
                                    //   ),
                                    // ],
                                  ),
                                ),
                              ],
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
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[900],
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.mail,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Enter Your Email',
                                        hintStyle: const TextStyle(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      validator: (value) {
                                        final RegExp emailRegex = RegExp(
                                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                                        if (value!.isEmpty) {
                                          return 'Please enter valid email';
                                        } else if (!emailRegex
                                            .hasMatch(value)) {
                                          return 'Please enter valid email';
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
                                  if (isLoading)
                                    const Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  else
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          errorMessage = null;
                                          isLoading = true;
                                        });

                                        final bool valid =
                                            formKey.currentState!.validate();
                                        if (valid) {
                                          final ForgotPasswordResponse?
                                              forgotPasswordResponse =
                                              await YogitunesAPI()
                                                  .forgotPassword(
                                            emailController.text,
                                          );

                                          if (forgotPasswordResponse != null) {
                                            if (forgotPasswordResponse
                                                .status!) {
                                              Navigator.popAndPushNamed(context,
                                                  '/forgotPasswordVerification',
                                                  arguments: {
                                                    'email':
                                                        emailController.text,
                                                  });
                                            } else {
                                              errorMessage =
                                                  forgotPasswordResponse.data
                                                      .toString();
                                            }
                                          } else {
                                            errorMessage = 'Server Down!!!';
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
                                          child:  Text(
                                            'Send Verification Code',
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
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .disclaimer,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .disclaimerText,
                                          style: TextStyle(
                                            color: Colors.grey.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
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
