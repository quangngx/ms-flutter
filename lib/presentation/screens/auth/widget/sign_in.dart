import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/screens/auth/widget/socials_widget.dart';
import 'package:masterstudy_app/presentation/screens/restore_password/restore_password_screen.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';
import 'package:masterstudy_app/presentation/widgets/base_text_field.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();
  bool _obscureText = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SuccessSignInState) {
          context.read<NavigationBloc>().add(ChangeNavEvent(4));
        }

        if (state is ErrorSignInState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showFlutterToast(
              title: state.message,
              gravity: ToastGravity.BOTTOM_LEFT,
            ),
          );
        }

        // Socials State
        if (state is SuccessAuthSocialsState) {
          if (state.photoUrl != null) {
            BlocProvider.of<EditProfileBloc>(context).add(UploadPhotoProfileEvent(state.photoUrl));
          }

          context.read<NavigationBloc>().add(ChangeNavEvent(4));
        }

        if (state is ErrorAuthSocialsState) {
          GoogleSignInProvider().logoutGoogle();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              title: 'error_dialog_title'.tr(),
              content: state.message,
              onPressed: () => BlocProvider.of<AuthBloc>(context).add(CloseDialogEvent()),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          bool enableInputs = state is! LoadingSignInState;

          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  BaseTextField(
                    controller: _loginController,
                    enabled: enableInputs,
                    labelText: 'login_label_text'.tr(),
                    helperText: 'login_sign_in_helper_text'.tr(),
                    hasFocus: _focusNode.hasFocus,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'login_sign_in_helper_text'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  BaseTextField(
                    controller: _passwordController,
                    enabled: enableInputs,
                    obscureText: _obscureText,
                    labelText: 'password_label_text'.tr(),
                    helperText: 'password_sign_in_helper_text'.tr(),
                    hasFocus: _focusNode.hasFocus,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      color: ColorApp.mainColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'password_sign_in_helper_text'.tr();
                      }

                      if (value.length < 4) {
                        return 'password_sign_in_characters_count_error_text'.tr();
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  AppElevatedButton.primary(
                    onPressed: state is LoadingSignInState
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              if (_loginController.text == 'demoapp' && _passwordController.text == 'demoapp') {
                                preferences.setBool(PreferencesName.demoMode, true);

                                BlocProvider.of<AuthBloc>(context).add(
                                  SignInEvent(
                                    _loginController.text,
                                    _passwordController.text,
                                  ),
                                );
                              } else {
                                BlocProvider.of<AuthBloc>(context).add(
                                  SignInEvent(
                                    _loginController.text,
                                    _passwordController.text,
                                  ),
                                );
                              }
                            }
                          },
                    child: state is LoadingSignInState
                        ? LoaderWidget()
                        : Text(
                            'sign_in_button'.tr(),
                          ),
                  ),
                  TextButton(
                    child: Text(
                      'restore_password_button'.tr(),
                      style: TextStyle(color: ColorApp.mainColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestorePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Socials Sign In
                  SocialsWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
