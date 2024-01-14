import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/cubits/register_cubit/register_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static String registerScreenID = "RegisterScreenID";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final passwordController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: autoValidateMode,
                key: formKey,
                child: BlocProvider(
                  create: (context) => RegisterCubit(),
                  child: BlocConsumer<RegisterCubit, RegisterStates>(
                    listener: (context, state) {
                      if (state is RegisterSuccessfulState) {
                        if (state.userModel.status) {
                          print("Message:${state.userModel.message}");
                          print(state.userModel.data!.token);
                          showMsgToast(context,
                              msg: state.userModel.message!,
                              state: ToastStates.SUCCESS);
                          Navigator.pop(context);
                        } else {
                          showMsgToast(context,
                              msg: state.userModel.message!,
                              state: ToastStates.ERROR);
                          if (kDebugMode) {
                            print(state.userModel.message);
                          }
                        }
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Join us now!",
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
                            height: 50,
                          ),
                          Text(
                            "REGISTER",
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Register to browse our hot offers!",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
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
                            label: 'Full Name',
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please, enter your name';
                              }
                              return null;
                            },
                            hint: 'Full Name',
                            prefix: Icons.person_2_outlined,
                          ),
                          const SizedBox(
                            height: 15,
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
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return 'Password is too weak';
                              }
                              return null;
                            },
                            isPassword: RegisterCubit.get(context).isVisible,
                            hint: 'Password',
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: RegisterCubit.get(context).suffixIcon,
                            suffixPressed: () {
                              RegisterCubit.get(context).changeVisibility();
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          customTextFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please, enter your phone number';
                              }
                              return null;
                            },
                            hint: 'Phone Number',
                            label: 'Phone Number',
                            prefix: Icons.phone,
                            onSubmit: (value) async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await RegisterCubit.get(context).registerUser(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              } else {
                                autoValidateMode = AutovalidateMode.always;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          state is! RegisterLoadingState
                              ? customButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      await RegisterCubit.get(context)
                                          .registerUser(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        phone: phoneController.text,
                                      );
                                    } else {
                                      autoValidateMode =
                                          AutovalidateMode.always;
                                    }
                                  },
                                  text: "REGISTER",
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                )),
                          Row(
                            children: [
                              const Text(
                                'Already have an account!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              customTextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: "LOGIN",
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
