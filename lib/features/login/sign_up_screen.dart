
import 'package:expenseapp/commons/widgets/email_textField.dart';
import 'package:expenseapp/commons/widgets/pswd_textfield.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  final emailController = TextEditingController();
  final pswdController = TextEditingController();
  final confirmPswdController = TextEditingController();
  String userEmail = '';

  @override
  void dispose() {
    emailController.dispose();
    pswdController.dispose();
    confirmPswdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) => Scaffold(body: SingleChildScrollView(child: form())),
    );
  }

  Widget form() {
    final size = context;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: size.height * UiUtils.vtMarginPct, horizontal: size.shortestSide * UiUtils.hzMarginPct + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.height * .06),
            Row(
              children: [
                GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Icon(Icons.arrow_back_rounded, size: 24, color: Theme.of(context).colorScheme.onTertiary),
                ),
              ],
            ),
            SizedBox(height: size.height * .02),
            CustomTextView(text: context.tr('signUpLbl'), fontSize: 40.sp(context), fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onTertiary),
            CustomTextView(text: context.tr('createAccDesLbl'), fontSize: 18.sp(context), fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 98, 96, 96)),
            SizedBox(height: size.height * .05),
            EmailTextField(controller: emailController),
            SizedBox(height: size.height * .02),
            PswdTextField(controller: pswdController),
            SizedBox(height: size.height * .02),
            PswdTextField(
              controller: confirmPswdController,
              hintText: "${context.tr("cnPwdLbl")}*",
              validator: (val) {
                if (val != pswdController.text) {
                  return context.tr('cnPwdNotMatchMsg');
                }
                return null;
              },
            ),
            SizedBox(height: size.height * .04),
            signupButton(),
            SizedBox(height: size.height * .02),
            showGoSignIn(),
            SizedBox(height: size.height * .04),
          ],
        ),
      ),
    );
  }

  Widget showGoSignIn() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.tr('alreadyAccountLbl'),
          style: TextStyle(fontSize: 18.sp(context), color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.4)),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Text(
            context.tr('loginKey'),
            style: TextStyle(
              fontSize: 18.sp(context),
              fontWeight: FontWeights.bold,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).primaryColor,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget signupButton() {
    return CustomRoundedButton(
      backgroundColor: Theme.of(context).primaryColor,
      textStyle: TextStyle(fontSize: 20.sp(context)),
      text: context.tr('signUpLbl'),
      borderRadius: BorderRadius.circular(10),

      height: (context.isMobile ? context.height * 0.05 : context.height * 0.04),
      onPressed: () {
        if (_formKey.currentState!.validate()) {}
      },
    );
  }

  void resetForm() {
    setState(() {
      isLoading = false;
      emailController.text = '';
      pswdController.text = '';
      confirmPswdController.text = '';
      _formKey.currentState!.reset();
    });
  }
}
