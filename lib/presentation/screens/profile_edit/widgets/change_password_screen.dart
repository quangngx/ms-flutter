import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/change_password/change_password_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';
import 'package:masterstudy_app/presentation/widgets/base_text_field.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen() : super();

  static const String routeName = '/changePasswordScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'change_password'.tr(),
          style: kAppBarTextStyle,
        ),
        backgroundColor: ColorApp.mainColor,
      ),
      body: BlocProvider(
        create: (context) => ChangePasswordBloc(),
        child: ChangePasswordWidget(),
      ),
    );
  }
}

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is SuccessChangePasswordState) {
          showFlutterToast(
            title: 'password_is_changed'.tr(),
          );

          Navigator.of(context).pop();
        }

        if (state is ErrorChangePasswordState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(context, title: state.message),
          );
        }
      },
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
          final enableInputs = !(state is LoadingChangePasswordState);

          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(
                children: <Widget>[
                  BaseTextField(
                    controller: _oldPasswordController,
                    enabled: enableInputs,
                    validator: (val) {
                      if (val!.isEmpty) return 'password_empty_error_text'.tr();

                      return null;
                    },
                    labelText: 'current_password'.tr(),
                    helperText: 'current_password_helper'.tr(),
                    obscureText: _obscureText,
                    hasFocus: _focusNode.hasFocus,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: ColorApp.mainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  BaseTextField(
                    controller: _newPasswordController,
                    enabled: enableInputs,
                    obscureText: _obscureText1,
                    validator: (val) {
                      if (val!.isEmpty) return 'password_empty_error_text'.tr();

                      if (val.length < 8) {
                        return 'password_register_characters_count_error_text'.tr();
                      }

                      if (RegExp(r'^[a-zA-Z]+$').hasMatch(val)) {
                        return 'password_register_characters_count_error_text'.tr();
                      }
                      return null;
                    },
                    labelText: 'new_password'.tr(),
                    helperText: 'password_registration_helper_text'.tr(),
                    hasFocus: _focusNode.hasFocus,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility : Icons.visibility_off,
                        color: ColorApp.mainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                    ),
                  ),
                  BaseTextField(
                    controller: _newPasswordConfirmController,
                    enabled: enableInputs,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'password_empty_error_text'.tr();
                      }

                      if (_newPasswordController.text != _newPasswordConfirmController.text) {
                        return 'password_dont_match'.tr();
                      }

                      return null;
                    },
                    obscureText: _obscureText2,
                    labelText: 'confirm_password'.tr(),
                    helperText: 'confirm_password_helper'.tr(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility : Icons.visibility_off,
                        color: ColorApp.mainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                    hasFocus: _focusNode.hasFocus,
                  ),
                  const SizedBox(height: 20.0),
                  AppElevatedButton.primary(
                    child: state is LoadingChangePasswordState
                        ? LoaderWidget()
                        : Text(
                            'change_password'.tr(),
                          ),
                    onPressed: state is LoadingChangePasswordState
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<ChangePasswordBloc>(context).add(
                                SendChangePasswordEvent(
                                  _oldPasswordController.text,
                                  _newPasswordController.text,
                                ),
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
