import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

import '../cubits/home_layout_cubit/home_layout_cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  bool currentPasswordVisible = true;
  bool newPasswordVisible = true;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool isVisible = true;

  @override
  void initState() {
    newPasswordController.clear();
    currentPasswordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
      listener: (context, state) {
        if (state is HomeUpdateUserPasswordSuccessfulState) {
          if (state.changePasswordModel.status!) {
            print("Message:${state.changePasswordModel.message}");
            showMsgToast(
              context,
              msg: state.changePasswordModel.message.toString(),
              state: ToastStates.SUCCESS,
            );
            Navigator.pop(context);
          } else {
            showMsgToast(context,
                msg: state.changePasswordModel.message.toString(),
                state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                    Image.asset("assets/images/shanta.png", fit: BoxFit.contain)
                        .image,
              ),
            ),
            scrolledUnderElevation: 0,
            titleSpacing: 4,
            title: Text(
              'Shanta',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 36,
                    fontFamily: 'Caveat',
                  ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: autoValidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Change Password",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 50),
                      customTextFormField(
                        label: 'Current Password',
                        controller: currentPasswordController,
                        type: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Password is too weak';
                          }
                          return null;
                        },
                        hint: 'Current Password',
                        prefix: Icons.lock_outline,
                        suffix: currentPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        isPassword: currentPasswordVisible,
                        suffixPressed: () {
                          setState(() {
                            currentPasswordVisible = !currentPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      customTextFormField(
                        label: 'New Password',
                        controller: newPasswordController,
                        type: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Password is too weak';
                          }
                          return null;
                        },
                        hint: 'New Password',
                        prefix: Icons.lock_outline,
                        suffix: newPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        isPassword: newPasswordVisible,
                        suffixPressed: () {
                          setState(() {
                            newPasswordVisible = !newPasswordVisible;
                          });
                        },
                        onSubmit: (value) {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            updateUserPassword(context);
                          } else {
                            autoValidateMode = AutovalidateMode.always;
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      state is! HomeUpdateUserPasswordLoadingState
                          ? customButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  updateUserPassword(context);
                                } else {
                                  autoValidateMode = AutovalidateMode.always;
                                }
                              },
                              text: "Update Password",
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> updateUserPassword(BuildContext context) async {
    await HomeLayoutCubit.get(context).changeUserPassword(
      current_password: currentPasswordController.text,
      new_password: newPasswordController.text,
    );
  }
}
