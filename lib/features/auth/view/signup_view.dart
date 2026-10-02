import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/features/auth/cubit/auth_cubit.dart';
import 'package:hunhry_food/features/auth/cubit/auth_state.dart';
import 'package:hunhry_food/features/auth/data/auth_repo.dart';
import 'package:hunhry_food/features/auth/view/login_view.dart';
import 'package:hunhry_food/features/auth/widgets/custom_button.dart';
import 'package:hunhry_food/root.dart';
import 'package:hunhry_food/shared/custom_snackbar.dart';
import 'package:hunhry_food/shared/custom_text.dart';
import 'package:hunhry_food/shared/custom_text_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  // TextEditingController confirmPassController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    // confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final cubit = context.read<AuthCubit>();
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
          FocusManager.instance.primaryFocus?.unfocus();
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
                  child: Column(
                    children: [
                      Gap(170),

                      SvgPicture.asset(
                        'assets/text_logo/Hungry_.svg',
                        height: 45,
                      ),
                      Gap(3),
                      CustomText(
                        text: 'Welcome to our Food App ',
                        color: Colors.grey.shade800,
                      ),
                      Gap(80),
                      SizedBox(
                        height: 600,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              Gap(30),
                              CustomTextField(
                                hintText: 'Name',
                                isPassword: false,
                                controller: nameController,
                              ),
                              Gap(20),
                              CustomTextField(
                                hintText: 'Email Adress',
                                isPassword: false,
                                controller: emailController,
                              ),
                              Gap(20),
                              CustomTextField(
                                hintText: 'password',
                                isPassword: true,
                                controller: passwordController,
                              ),

                              Gap(25),
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (BuildContext context, state) {
                                  final loading = state is AuthLoading;

                                  return CustomAuthButton(
                                    text: "Sign up",
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    widget: loading
                                        ? CupertinoActivityIndicator(
                                            color: Colors.grey,
                                          )
                                        : null,
                                    onTap: () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }
                                      cubit.signUp(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                        name: nameController.text
                                            .trim()
                                            .toLowerCase(),
                                      );
                                    },
                                  );
                                },
                              ),
                              Gap(20),
                              CustomAuthButton(
                                textColor: AppColor.primary,
                                text: "Go To Login",
                                color: Colors.white,

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginView(),
                                    ),
                                  );
                                },
                              ),
                            ],
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
    );
  }
}
