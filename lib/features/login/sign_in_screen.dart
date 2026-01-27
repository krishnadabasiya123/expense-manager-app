import 'package:expenseapp/commons/widgets/BottomNavigationPageChange.dart';
import 'package:expenseapp/commons/widgets/email_textField.dart';
import 'package:expenseapp/commons/widgets/pswd_textfield.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDialog = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController forgotPswdController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    forgotPswdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ResponsivePadding(
        child: Center(child: SingleChildScrollView(child: _buildForm(size))),
      ),
    );
  }

  Widget _buildForm(Size size) {
    return Form(
      key: _formKey,
      child: ResponsivePadding(
        child: Column(
          crossAxisAlignment: .start,
          //mainAxisSize: .min,
          //   mainAxisAlignment: .center,
          children: [
            CustomTextView(text: context.tr('loginKey'), fontSize: 40.sp(context), fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onTertiary),
            CustomTextView(text: context.tr('letsGetStartedLbl'), fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 98, 96, 96)),

            SizedBox(height: size.height * 0.05),
            ..._buildEmailLoginMethod(context, size.height),
            SizedBox(height: size.height * 0.02),
            orLabel(),
            SizedBox(height: size.height * 0.03),
            loginWith(),
            SizedBox(height: size.height * 0.01),
            _buildSocialMediaLoginMethods(context, size.height),
          ],
        ),
      ),
    );
  }

  Widget loginWith() {
    return Center(
      child: CustomTextView(
        text: context.tr('loginSocialMediaLbl'),
        textAlign: TextAlign.center,
        fontWeight: FontWeights.regular,
        color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.4),
        fontSize: 16.sp(context),
      ),
    );
  }

  List<Widget> _buildEmailLoginMethod(BuildContext context, double height) {
    return [
      EmailTextField(controller: _emailController, isDesne: true),
      SizedBox(height: height * 0.02),
      PswdTextField(controller: _passwordController, isDense: true),
      SizedBox(height: height * .01),
      forgetPwd(),
      SizedBox(height: height * 0.01),
      showSignIn(context),
      SizedBox(height: height * 0.008),
      showWithoutSignIn(context),
      SizedBox(height: height * 0.02),
      showGoSignup(),
    ];
  }

  Widget _buildSocialMediaLoginMethods(BuildContext context, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGmailLoginIconButton(context),
        if (!Platform.isIOS)
          Row(
            children: [
              SizedBox(width: height * 0.02),
              _buildAppleLoginIconButton(context),
            ],
          )
        else
          Container(),
      ],
    );
  }

  Widget _buildGmailLoginIconButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
        alignment: Alignment.center,
        padding: const EdgeInsetsDirectional.all(12),
        child: SvgPicture.asset(AppImages.googleIcon, height: 38, width: 38),
      ),
    );
  }

  Widget _buildAppleLoginIconButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
        alignment: Alignment.center,
        padding: const EdgeInsetsDirectional.all(12),
        child: SvgPicture.asset(AppImages.appleIcon, height: 38, width: 38),
      ),
    );
  }

  Padding forgetPwd() {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          splashColor: Colors.white,
          child: Text(
            context.tr('forgotPwdLbl'),
            style: TextStyle(fontWeight: FontWeights.regular, fontSize: 14, height: 1.21, color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.4)),
          ),
          onTap: () async {
            await showModalBottomSheet<void>(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(borderRadius: UiUtils.bottomSheetTopRadius),
              context: context,
              builder: (context) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: UiUtils.bottomSheetTopRadius),
                  constraints: BoxConstraints(maxHeight: context.height * 0.41),
                  child: Form(
                    key: _formKeyDialog,
                    child: ResponsivePadding(
                      topPadding: context.height * 0.02,
                      bottomPadding: context.height * 0.02,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.tr('resetPwdLbl'),
                            style: TextStyle(fontSize: 30.sp(context), color: Theme.of(context).colorScheme.onTertiary, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: context.height * 0.01),
                          Text(
                            context.tr('resetEnterEmailLbl'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onTertiary,
                              fontWeight: FontWeight.w600, // FontWeights.semiBold does not exist
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: context.height * 0.02),

                          /// Email input
                          EmailTextField(controller: forgotPswdController),

                          SizedBox(height: context.height * 0.03),

                          /// Submit button
                          CustomRoundedButton(
                            backgroundColor: Theme.of(context).primaryColor,
                            text: context.tr('submitBtn'),
                            borderRadius: BorderRadius.circular(10),

                            height: context.height * 0.06,
                            onPressed: () {
                              final form = _formKeyDialog.currentState;
                              if (form!.validate()) {
                                form.save();
                                UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('pwdResetLinkLbl'));

                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.pop(context, 'Cancel');
                                });

                                forgotPswdController.text = '';
                                form.reset();
                              }
                            },
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
      ),
    );
  }

  Widget showSignIn(BuildContext context) {
    return CustomRoundedButton(
      backgroundColor: Theme.of(context).primaryColor,
      text: context.tr('loginKey'),
      borderRadius: BorderRadius.circular(10),
      height: (context.isMobile ? context.height * 0.05 : context.height * 0.04),
      onPressed: () {
        if (_formKey.currentState!.validate()) {}
      },
    );
  }

  Widget showWithoutSignIn(BuildContext context) {
    return CustomRoundedButton(
      backgroundColor: Theme.of(context).colorScheme.surface,
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
      text: context.tr('continueWithoutSignIn'),
      borderRadius: BorderRadius.circular(10),
      height: (context.isMobile ? context.height * 0.05 : context.height * 0.04),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.bottomNavigationBar);
        bottomNavKey.currentState?.changeTab(0);
      },
    );
  }

  Widget showGoSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.tr('noAccountLbl'),
          style: TextStyle(fontSize: 16.sp(context), fontWeight: FontWeights.regular, color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.4)),
        ),
        const SizedBox(width: 4),
        CupertinoButton(
          onPressed: () {
            _formKey.currentState!.reset();
            Navigator.of(context).pushNamed(Routes.signUp);
          },
          padding: EdgeInsetsDirectional.zero,
          child: Text(
            context.tr('signUpLbl'),
            style: TextStyle(
              fontSize: 16.sp(context),
              fontWeight: FontWeights.regular,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).primaryColor,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget orLabel() {
    return Center(
      child: Text(
        context.tr('orLbl'),
        style: TextStyle(fontWeight: FontWeights.regular, color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.4)),
      ),
    );
  }
}
