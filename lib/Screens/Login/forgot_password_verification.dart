import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/model/forgot_password_verification_response.dart';
import 'package:flutter/material.dart';

class ForgotPasswordVerificationScreen extends StatefulWidget {
  const ForgotPasswordVerificationScreen();

  static const String route = '/forgotPasswordVerification';

  @override
  _ForgotPasswordVerificationScreenState createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends State<ForgotPasswordVerificationScreen> {
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RichText(
                              text: TextSpan(
                                text:
                                    'An email is on it\'s way with instruction to access your account. Enter the verification code from that email below.',
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
                                      controller: passwordController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.name,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Enter Verification Code',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter verification code';
                                        } else if (value.length < 8 ||
                                            value.length > 8) {
                                          return 'Enter valid verification code';
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
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  else
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          errorMessage = null;
                                          isLoading = true;
                                        });
                                        print(args['email'].toString());
                                        final bool valid =
                                            formKey.currentState!.validate();
                                        if (valid) {
                                          ForgotPasswordVerificationResponse?
                                              forgotPasswordVerificationResponse =
                                              await YogitunesAPI()
                                                  .forgotPasswordVerification(
                                            args['email'].toString(),
                                            passwordController.text,
                                          );

                                          if (forgotPasswordVerificationResponse !=
                                              null) {
                                            if (forgotPasswordVerificationResponse
                                                .status!) {
                                              Navigator.pushNamed(
                                                  context, '/resetPassword');
                                            } else {
                                              errorMessage =
                                                  forgotPasswordVerificationResponse
                                                      .data
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
                                          child: Text(
                                            'Verify Code',
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
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Text(
                                      'Have you been patiently waiting for more than two minutes?',
                                      style: TextStyle(
                                        color: Colors.grey.withOpacity(0.7),
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
