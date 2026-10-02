import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/features/auth/cubit/auth_cubit.dart';
import 'package:hunhry_food/features/auth/cubit/auth_state.dart';
import 'package:hunhry_food/features/auth/view/signup_view.dart';
import 'package:hunhry_food/features/auth/widgets/custom_button.dart';
import 'package:hunhry_food/root.dart';
import 'package:hunhry_food/shared/custom_snackbar.dart';
import 'package:hunhry_food/shared/custom_text.dart';
import 'package:hunhry_food/shared/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Root()));
        }
        if (state is AuthError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: screenHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Gap(170),
                            SvgPicture.asset(
                              'assets/text_logo/Hungry_.svg',
                              height: 45,
                            ),
                            Gap(3),
                            CustomText(
                              text: 'welcom Back Discover The Fast Food',
                              color: Colors.grey.shade800,
                              size: 13,
                              weight: FontWeight.w600,
                            ),
                            Gap(80),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Gap(20),
                                      CustomTextField(
                                        hintText: 'Email Adress',
                                        isPassword: false,
                                        controller: emailController,
                                      ),
                                      Gap(30),

                                      CustomTextField(
                                        hintText: 'Password',
                                        isPassword: true,
                                        controller: passwordController,
                                      ),
                                      Gap(30),
                                      BlocBuilder<AuthCubit, AuthState>(
                                        builder: (context, state) {
                                          final loading = state is AuthLoading;
                                          return CustomAuthButton(
                                            text: "Login",
                                            textColor: Colors.white,
                                            color: Colors.transparent,
                                            widget: loading
                                                ? CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  )
                                                : null,
                                            onTap: () {
                                              if (!formKey.currentState!
                                                  .validate()) {
                                                return;
                                              }
                                              context.read<AuthCubit>().login(
                                                email: emailController.text
                                                    .trim(),
                                                password: passwordController
                                                    .text
                                                    .trim(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      Gap(20),
                                      CustomAuthButton(
                                        textColor: AppColor.primary,
                                        text: "Greate Account ?",
                                        color: Colors.white,

                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (c) => SignupView(),
                                            ),
                                          );
                                        },
                                      ),
                                      Gap(40),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (c) {
                                                return Root();
                                              },
                                            ),
                                          );
                                        },
                                        child: CustomText(
                                          text: 'Continue as a guest ?',
                                          color: Colors.white,
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                      Gap(10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
