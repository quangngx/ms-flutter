import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/screens/auth/widget/socials_widget.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';
import 'package:masterstudy_app/presentation/widgets/base_text_field.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();

  bool _obscureText = true;

  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // SignUpState
        if (state is SuccessSignUpState) {
          context.read<NavigationBloc>().add(ChangeNavEvent(4));
        }

        if (state is ErrorSignUpState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showFlutterToast(title: state.message),
          );
        }

        // DemoAuthState
        if (state is SuccessDemoAuthState) {
          context.read<NavigationBloc>().add(ChangeNavEvent(4));
        }

        if (state is ErrorDemoAuthState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              content: state.message,
              onPressed: () => BlocProvider.of<AuthBloc>(context).add(CloseDialogEvent()),
            ),
          );
        }

        // SocialsState
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
              content: state.message,
              onPressed: () => BlocProvider.of<AuthBloc>(context).add(CloseDialogEvent()),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          bool enableInputs = state is! LoadingSignUpState;

          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  BaseTextField(
                    controller: _loginController,
                    enabled: enableInputs,
                    hasFocus: _focusNode.hasFocus,
                    labelText: 'login_label_text'.tr(),
                    helperText: 'login_registration_helper_text'.tr(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'login_empty_error_text'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  BaseTextField(
                    controller: _emailController,
                    enabled: enableInputs,
                    hasFocus: _focusNode.hasFocus,
                    labelText: 'email_label_text'.tr(),
                    helperText: 'email_helper_text'.tr(),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 20.0),
                  BaseTextField(
                    controller: _passwordController,
                    enabled: enableInputs,
                    hasFocus: _focusNode.hasFocus,
                    obscureText: _obscureText,
                    labelText: 'password_label_text'.tr(),
                    helperText: 'password_registration_helper_text'.tr(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password_empty_error_text'.tr();
                      }
                      if (value.length < 8) {
                        return 'password_register_characters_count_error_text'.tr();
                      }

                      return null;
                    },
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
                  ),
                  const SizedBox(height: 20.0),
                  AppElevatedButton.primary(
                    onPressed: state is LoadingSignUpState
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                SignUpEvent(
                                  _loginController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                            }
                          },
                    child: state is LoadingSignUpState
                        ? LoaderWidget()
                        : Text(
                            'registration_button'.tr(),
                          ),
                  ),
                  if (demoEnabled ?? true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: AppElevatedButton.primary(
                        onPressed: state is LoadingDemoAuthState
                            ? null
                            : () => BlocProvider.of<AuthBloc>(context).add(DemoAuthEvent()),
                        child: state is LoadingDemoAuthState
                            ? LoaderWidget()
                            : Text(
                                'registration_demo_button'.tr(),
                              ),
                      ),
                    ),
                  const SizedBox(height: 20.0),
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
