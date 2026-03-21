import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/services/auth_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:cctv_app/feature/bottomNavBar/user_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isSubmitting = false;

  Future<void> _submit() async {
    if (isSubmitting) return;
    if (formKey.currentState?.validate() != true) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final service = AuthService(
        ApiClient(baseUrl: ApiConfig.baseUrl),
      );

      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final email = emailController.text.trim();
      final response = await service.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: passwordController.text,
      );

      final accessToken = response.accessToken ?? response.token;
      final userId = response.content?.userId;

      if (accessToken == null || userId == null) {
        throw const ApiException('Signup succeeded but auth data is missing');
      }

      await const AuthStorage().saveAuth(
        accessToken: accessToken,
        userId: userId,
        roleId: response.content?.roleId ?? 1,
        roleDescription: 'user',
        firstName: response.content?.firstName ?? firstName,
        lastName: response.content?.lastName ?? lastName,
        email: response.content?.userEmail ?? email,
        dashboardType: DashboardType.user,
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const UserBottomNavBar()),
        (_) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: "First Name",
            controller: firstNameController,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.firstName(value);
            },
            suffix: const Icon(Icons.person_outline, color: kDarkGreyColor),
          ),
          Space.vertical(14),
          CustomTextField(
            hintText: "Last Name",
            controller: lastNameController,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.lastName(value);
            },
            suffix: const Icon(Icons.person_outline, color: kDarkGreyColor),
          ),
          Space.vertical(14),
          CustomTextField(
            hintText: "Email",
            controller: emailController,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.email(value);
            },
            suffix: const Icon(Icons.email_outlined, color: kDarkGreyColor),
          ),
          Space.vertical(14),
          CustomTextField(
            hintText: "Password",
            controller: passwordController,
            obscureText: obscurePassword,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.password(value);
            },
            suffix: CupertinoButton(
              child: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.remove_red_eye_outlined,
                color: kDarkGreyColor,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
          Space.vertical(14),
          CustomTextField(
            hintText: "Confirm Password",
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              if (passwordController.text != confirmPasswordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
            suffix: CupertinoButton(
              child: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.remove_red_eye_outlined,
                color: kDarkGreyColor,
              ),
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
            ),
          ),
          Space.vertical(20),
          PrimaryButton(
            text: "Signup",
            isMainAxisSizeMin: true,
            padding: EdgeInsets.symmetric(horizontal: 50),
            processing: isSubmitting,
            inactive: isSubmitting,
            onPressed: () {
              _submit();
            },
          ),
        ],
      ),
    );
  }
}
