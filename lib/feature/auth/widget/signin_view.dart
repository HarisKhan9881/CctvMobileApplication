import 'package:cctv_app/core/components/app_alert.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/services/auth_service.dart';
import 'package:cctv_app/core/realtime/app_websocket_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:cctv_app/feature/bottomNavBar/ad_bottom_nav_bar.dart';
import 'package:cctv_app/feature/bottomNavBar/admin_bottom_nav_bar.dart';
import 'package:cctv_app/feature/bottomNavBar/user_bottom_nav_bar.dart';
import 'package:cctv_app/feature/forgotPassword/pages/forgot_pasword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninView extends StatefulWidget {
  final bool isAdminTab;
  const SigninView({super.key, required this.isAdminTab});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isSubmitting = false;

  DashboardType _dashboardTypeFromRole({String? roleDescription, int? roleId}) {
    final normalizedRole = roleDescription?.trim().toLowerCase();
    if (normalizedRole == 'super admin') return DashboardType.admin;
    if (normalizedRole == 'admin') return DashboardType.admin;
    if (normalizedRole == 'ad') return DashboardType.ad;
    if (normalizedRole == 'user') return DashboardType.user;

    return switch (roleId) {
      2 => DashboardType.admin,
      3 => DashboardType.admin,
      1 => DashboardType.user,
      _ => DashboardType.user,
    };
  }

  Widget _dashboardFromType(DashboardType type) {
    return switch (type) {
      DashboardType.admin => const AdminBottomNavBar(),
      DashboardType.user => const UserBottomNavBar(),
      DashboardType.ad => const AdBottomNavBar(),
    };
  }

  String _loginErrorMessage(ApiException error) {
    final message = error.message.toLowerCase();
    final isCredentialIssue =
        error.statusCode == 401 ||
        message.contains('invalid credential') ||
        message.contains('invalid username') ||
        message.contains('invalid password') ||
        message.contains('incorrect username') ||
        message.contains('incorrect password') ||
        message.contains('username or password') ||
        message.contains('bad credentials') ||
        message.contains('unauthorized');

    if (isCredentialIssue) {
      return 'Credentials issue please check username or password';
    }

    return error.message;
  }

  Future<void> _submit() async {
    if (isSubmitting) return;
    if (formKey.currentState?.validate() != true) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final service = AuthService(ApiClient(baseUrl: ApiConfig.baseUrl));
      final username = emailController.text.trim();
      final response = await service.login(
        username: username,
        password: passwordController.text,
      );

      final accessToken = response.accessToken ?? response.token;
      final user = response.content;
      if (accessToken == null || user == null) {
        throw const ApiException('Login succeeded but auth data is missing');
      }

      final dashboardType = _dashboardTypeFromRole(
        roleDescription: user.roleDescription,
        roleId: user.roleId,
      );
      await AuthStorage().saveAuth(
        accessToken: accessToken,
        userId: user.userId,
        roleId: user.roleId,
        roleDescription: user.roleDescription,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.userEmail ?? username,
        dashboardType: dashboardType,
      );

      await AppWebSocketService.instance.connect(accessToken: accessToken);

      if (!mounted) return;
      final dashboard = _dashboardFromType(dashboardType);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => dashboard),
        (_) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      AppAlert.showError(context, _loginErrorMessage(e));
    } catch (e) {
      if (!mounted) return;
      AppAlert.showError(context, 'Login failed: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: "Email",
            controller: emailController,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.email(value);
            },
            suffix: const Icon(Icons.email_outlined, color: kDarkGreyColor),
          ),
          Space.vertical(16),
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
          Space.vertical(16),
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              child: Text(
                "Forget password",
                style: context.medium.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasword(),
                  ),
                );
              },
            ),
          ),
          Space.vertical(30),
          PrimaryButton(
            text: "Login",
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
