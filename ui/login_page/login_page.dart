import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugc_esports/configuration_files/form_config.dart';
import 'package:ugc_esports/global_members.dart';
import 'package:ugc_esports/network_connectivity_handler.dart';
import 'package:ugc_esports/repository/model_classes/login.dart';
import 'package:ugc_esports/repository/providers/ui_providers.dart';
import 'package:ugc_esports/ui/colors.dart';
import 'package:ugc_esports/ui/home_page/home_page.dart';
import 'package:ugc_esports/ui/widgets.dart';

/*class LoginToken {
  final Map<String, dynamic> data;

  LoginToken({required this.data});
}*/

class LoginPage extends StatelessWidget {
  static const String routeName = '/';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: const Scaffold(
          backgroundColor: UGCColors.darkGrey,
          body: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with ConnectivityHandler{

  final _loginFormKey = GlobalKey<FormState>();
  late LoginApiClient loginApiClient;
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  @override
  void initState() {
    loginApiClient = Provider.of<LoginApiClient>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _loginFormKey,
      child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextInputField(
                    hintText: 'Email Address',
                    filled: true,
                    fillColor: Colors.white,
                    controller: _emailEditingController,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    keyBoardType: TextInputType.emailAddress,
                    inputFormatters: InputFormat.emailInputFormat,
                    validator: (value) =>
                        FormValidator.emailFieldValidator(value),
                  )),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Consumer<PasswordVisibilityNotifier>(
                    builder: (context, value, child) => TextInputField(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          Provider.of<PasswordVisibilityNotifier>(context,
                                  listen: false)
                              .password();
                        },
                        icon: Icon(
                          value.passwordVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      keyBoardType: TextInputType.text,
                      maxLines: 1,
                      letterSpacing: 2.0,
                      filled: true,
                      obscureText: value.passwordVisibility,
                      fillColor: Colors.white,
                      controller: _passwordEditingController,
                      inputFormatters: InputFormat.passwordInputFormat,
                      validator: (value) => FormValidator.textFieldValidator(
                          value: value, errorText: 'Enter Password'),
                    ),
                  )),
              // <----------------->  Login Button
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Consumer<LoginApiClient>(
                  builder: (context, value, child) => LoginButton(
                    child: value.isProcessing
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'SIGN IN',
                            style: TextStyle(
                                fontFamily: 'eurostile',
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                    size: MediaQuery.of(context).size,
                    onTap: () async {
                      if(!value.isProcessing) {
                        // await networkConnection.initialState();
                        UserLoginData userLogin;
                        if (_loginFormKey.currentState!.validate()) {
                          value.isProcessing = true;
                          value.notifyMe();
                          if(await checkForInternetServiceAvailability(context)) {
                            userLogin = await loginApiClient.login(UserLogin(
                                email: _emailEditingController.text,
                                password: _passwordEditingController.text));
                            if (userLogin.success == true) {
                              token = userLogin.data;
                              value.processingCompleted();
                              value.notifyMe();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in Successfully')));
                              Navigator.pushReplacementNamed(context, HomePage.routeName);
                              // Navigator.pushNamed(context, HomePage.routeName, arguments: LoginToken(data: userLogin.data),);
                            } else {
                              value.processingCompleted();
                              value.notifyMe();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check Email/Password')));
                            }
                          } else {
                            value.isProcessing = false;
                            value.notifyMe();
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(
                              fontFamily: "eurostile", color: Colors.white),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final Size? size;

  const LoginButton({Key? key, this.child, this.onTap, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: 306.0,
        alignment: Alignment.center,
        child: child,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
