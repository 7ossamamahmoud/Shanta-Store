import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/cubits/login_cubit/login_cubit.dart';
import 'package:salla/layout/home_screen.dart';
import 'package:salla/screens/register_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/local/shared_preference_helper.dart';
import 'package:salla/shared/styles/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String loginScreenID = 'LoginScreenID';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final logInPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool isVisible = true;

  @override
  void initState() {
    emailController.clear();
    logInPasswordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessfulState) {
            if (state.loginModel.status) {
              print("Message:${state.loginModel.message}");
              print("Token: ${state.loginModel.data!.token}");
              SharedPrefService.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                if (value) {
                  kToken = state.loginModel.data!.token!;
                  showMsgToast(context,
                      msg: state.loginModel.message.toString(),
                      state: ToastStates.SUCCESS);
                  navigateAndFinish(
                    context,
                    HomeScreen.homeScreenID,
                  );
                }
              });
            } else {
              showMsgToast(context,
                  msg: state.loginModel.message.toString(),
                  state: ToastStates.ERROR);
              print(state.loginModel.message);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: autoValidateMode,
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome back \")",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    fontFamily: 'Caveat',
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Text(
                          "LOGIN",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Shop smart, shop with us for a seamless retail experience!",
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontFamily: 'Caveat',
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        customTextFormField(
                          label: 'Email Address',
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please, enter your email address';
                            } else {
                              validateEmail(value);
                            }
                            return null;
                          },
                          hint: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        customTextFormField(
                          label: 'Password',
                          controller: logInPasswordController,
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password is too weak';
                            }
                            return null;
                          },
                          isPassword: LoginCubit.get(context).isVisible,
                          hint: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: LoginCubit.get(context).suffixIcon,
                          suffixPressed: () {
                            LoginCubit.get(context).changeVisibility();
                          },
                          onSubmit: (value) async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              await LoginCubit.get(context).loginUser(
                                email: emailController.text,
                                password: logInPasswordController.text,
                                context: context,
                              );
                            } else {
                              autoValidateMode = AutovalidateMode.always;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        state is! LoginLoadingState
                            ? customButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    await LoginCubit.get(context).loginUser(
                                      email: emailController.text,
                                      password: logInPasswordController.text,
                                      context: context,
                                    );
                                    emailController.clear();
                                    logInPasswordController.clear();
                                  } else {
                                    autoValidateMode = AutovalidateMode.always;
                                  }
                                },
                                text: "LOGIN",
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                              ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Don\'t have an account!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            customTextButton(
                              onPressed: () {
                                navigateTo(
                                    context, RegisterScreen.registerScreenID);
                                emailController.clear();
                                logInPasswordController.clear();
                              },
                              text: "REGISTER NOW",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
