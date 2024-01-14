import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/screens/change_password_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: HomeLayoutCubit.get(context).userData != null &&
          HomeLayoutCubit.get(context).homeModel != null,
      builder: (BuildContext context) {
        return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
          listener: (context, state) {
            if (state is HomeUpdateUserDataSuccessfulState) {
              if (state.userInfoModel.status!) {
                showMsgToast(
                  context,
                  msg: state.userInfoModel.message!,
                  state: ToastStates.SUCCESS,
                );
              } else {
                showMsgToast(
                  context,
                  msg: state.userInfoModel.message!,
                  state: ToastStates.ERROR,
                );
              }
            }
          },
          builder: (context, state) {
            File? profileImage = HomeLayoutCubit.get(context).profileImage;
            var userData = HomeLayoutCubit.get(context).userData;
            nameController.text = userData!.data!.name!;
            phoneController.text = userData.data!.phone!;
            emailController.text = userData.data!.email!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 83.0,
                            backgroundColor: kPrimaryColor,
                            child: CircleAvatar(
                              radius: 80.0,
                              backgroundImage:
                                  HomeLayoutCubit.get(context).profileImage ==
                                          null
                                      ? NetworkImage(userData!.data!.image!)
                                      : FileImage(
                                          HomeLayoutCubit.get(context)
                                              .profileImage!,
                                        ) as ImageProvider,
                            ),
                          ),
                          IconButton(
                            icon: const CircleAvatar(
                              radius: 20.0,
                              child: Icon(
                                FontAwesomeIcons.camera,
                                size: 17.0,
                              ),
                            ),
                            onPressed: () {
                              HomeLayoutCubit.get(context).getProfileImage();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    customTextFormField(
                      label: 'Username',
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
                      height: 25,
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
                      height: 25,
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
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              customButton(
                                onPressed: () async {
                                  await HomeLayoutCubit.get(context)
                                      .updateUserData(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text,
                                    image: profileImage!.toString(),
                                  );
                                },
                                text: 'Update Profile',
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              if (state is HomeUpdateUserDataLoadingState)
                                const LinearProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: customButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordScreen(),
                                  ),
                                );
                              },
                              text: 'Change Password'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      fallback: (BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
