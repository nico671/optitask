import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:optitask/caches/onboardingcontrol.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool phoneNumberEntered = false;
  TextEditingController phoneNumberController = TextEditingController();
  String completeNumber = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController codeController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * .75,
                    width: MediaQuery.of(context).size.width * .75,
                    // child: const Image(
                    //   image: AssetImage('assets/optitask@2x-01.png'),
                    // ),
                  ),
                ),
                Text(
                  'Welcome to OptiTask!',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: themeProvider.theme.primaryTextColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Press the button below to begin.',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: themeProvider.theme.primaryTextColor),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    height: 75,
                    width: MediaQuery.of(context).size.width * .9,
                    child: SignInButton(
                      // brightness == Brightness.dark
                      //     ? Buttons.GoogleDark
                      Buttons.Google,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        User? user;

                        final GoogleSignIn googleSignIn = GoogleSignIn();

                        final GoogleSignInAccount? googleSignInAccount =
                            await googleSignIn.signIn();

                        if (googleSignInAccount != null) {
                          final GoogleSignInAuthentication
                              googleSignInAuthentication =
                              await googleSignInAccount.authentication;

                          final AuthCredential credential =
                              GoogleAuthProvider.credential(
                            accessToken: googleSignInAuthentication.accessToken,
                            idToken: googleSignInAuthentication.idToken,
                          );

                          try {
                            final UserCredential userCredential =
                                await auth.signInWithCredential(credential);

                            user = userCredential.user;
                          } on FirebaseAuthException catch (e) {
                            if (e.code ==
                                'account-exists-with-different-credential') {
                              // ...
                            } else if (e.code == 'invalid-credential') {
                              // ...
                            }
                          } catch (e) {
                            // ...
                          }
                        }
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CheckOnboarding()));
                        }
                      },
                      text: "Sign up with Google",
                    ),
                  ),
                ),
                // IntlPhoneField(
                //   decoration: const InputDecoration(
                //     labelText: 'Phone Number',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(),
                //     ),
                //   ),
                //   initialCountryCode: 'US',
                //   onChanged: (value) {
                //     completeNumber = value.completeNumber;
                //   },
                //   onSubmitted: (p0) async {
                //     await auth.verifyPhoneNumber(
                //       verificationFailed: (error) {
                //         print(error.message);
                //       },
                //       phoneNumber: completeNumber,
                //       verificationCompleted: (phoneAuthCredential) {
                //         auth.signInWithCredential(phoneAuthCredential);
                //       },
                //       codeSent:
                //           (String verificationId, int? resendToken) async {
                //         showModalBottomSheet(
                //             context: context,
                //             builder: (
                //               context,
                //             ) {
                //               return SizedBox(
                //                 height:
                //                     MediaQuery.of(context).size.height / 2,
                //                 child: Center(
                //                   child: Column(
                //                     children: [
                //                       TextField(
                //                         controller: codeController,
                //                         decoration: const InputDecoration(
                //                           labelText: 'Enter SMS Code',
                //                           border: OutlineInputBorder(
                //                             borderRadius: BorderRadius.all(
                //                                 Radius.circular(10)),
                //                             borderSide: BorderSide(),
                //                           ),
                //                         ),
                //                       ),
                //                       ElevatedButton(
                //                           onPressed: () async {
                //                             PhoneAuthCredential credential =
                //                                 PhoneAuthProvider.credential(
                //                                     verificationId:
                //                                         verificationId,
                //                                     smsCode:
                //                                         codeController.text);

                //                             // Sign the user in (or link) with the credential
                //                             await auth
                //                                 .signInWithCredential(
                //                                     credential)
                //                                 .catchError((error) {
                //                               Toasta(context).toast(Toast(
                //                                   title: error.toString(),
                //                                   status:
                //                                       ToastStatus.failed));
                //                             });
                //                             Navigator.of(context).pushReplacement(
                //                                 MaterialPageRoute(
                //                                     builder: (context) =>
                //                                         const CheckOnboarding()));
                //                           },
                //                           child: const Text('Verify'))
                //                     ],
                //                   ),
                //                 ),
                //               );
                //             });

                //         // Create a PhoneAuthCredential with the code
                //       },
                //       codeAutoRetrievalTimeout: (String verificationId) {
                //         Toasta(context).toast(Toast(
                //           title: 'Code Auto Retrieval Timeout',
                //           status: ToastStatus.failed,
                //         ));
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
