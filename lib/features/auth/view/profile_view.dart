import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/features/auth/cubit/auth_cubit.dart';
import 'package:hunhry_food/features/auth/cubit/auth_state.dart';
import 'package:hunhry_food/features/auth/view/login_view.dart';
import 'package:hunhry_food/features/auth/widgets/custom_user_text_field.dart';
import 'package:hunhry_food/shared/custom_snackbar.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  @override
  void initState() {
    context.read<AuthCubit>().getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (BuildContext context, state) {
        if (state is ProfileSuccsess) {
          _name.text = state.name;
          _email.text = state.email;
          // _address.text = state.address;
        } else if (state is ProfileError) {
          CustomSnackBar.showError(context, message: state.message);
        } else if (state is LogoutSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        } else if (state is LogoutError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (BuildContext context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: AppColor.primary,
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: AppColor.primary,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  child: SvgPicture.asset(
                    'assets/icon/settings.svg',
                    width: 20,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlbbdPqXU3wwsJQPwkgU42saoIIg22ct8rNcFV_RU6PA&s=10',
                            ),
                          ),
                          color: Colors.grey.shade300,
                          border: Border.all(width: 5, color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Gap(20),
                    CustomUserTextField(controller: _name, label: 'Name'),
                    Gap(25),
                    CustomUserTextField(controller: _email, label: 'Email'),
                    Gap(25),
                    CustomUserTextField(controller: _address, label: 'Address'),
                    Gap(20),
                    Divider(),
                    Gap(10),
                    RadioGroup(
                      groupValue: 'Visa',
                      onChanged: (v) {},
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            tileColor: Color(0xffF3F4F6),
                            leading: Image.asset(
                              "assets/icon/prifile_visa.png",
                              width: 50,
                            ),
                            title: CustomText(
                              text: 'Debbit On Card',
                              color: Colors.black,
                            ),
                            subtitle: CustomText(
                              text: '**** ****** 2435',
                              color: Colors.black,
                            ),
                            trailing: CustomText(
                              text: 'Default',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            bottomSheet: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 12,
                    offset: Offset(0, 0),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CustomText(text: 'Edit Profile', color: Colors.white),
                          Gap(10),
                          Icon(CupertinoIcons.pencil, color: Colors.white),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<AuthCubit>().logout();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            CustomText(text: 'Logout', color: AppColor.primary),
                            Gap(10),
                            Icon(Icons.logout, color: AppColor.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
