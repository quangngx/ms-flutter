import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/presentation/bloc/restore_password/restore_password_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';
import 'package:masterstudy_app/presentation/widgets/base_text_field.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class RestorePasswordScreen extends StatefulWidget {
  static const String routeName = '/restorePasswordScreen';

  @override
  State<StatefulWidget> createState() => _RestorePasswordScreenState();
}

class _RestorePasswordScreenState extends State<RestorePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorApp.mainColor,
        title: Text(
          'restore_password_button'.tr(),
          style: kAppBarTextStyle,
        ),
      ),
      body: BlocProvider(
        create: (context) => RestorePasswordBloc(),
        child: BlocListener<RestorePasswordBloc, RestorePasswordState>(
          listener: (context, state) {
            if (state is SuccessRestorePasswordState) {
              _emailController.clear();

              showFlutterToast(
                title: 'restore_password_info'.tr(),
              );
            }
          },
          child: BlocBuilder<RestorePasswordBloc, RestorePasswordState>(
            builder: (context, state) {
              bool enableInputs = !(state is LoadingRestorePasswordState);

              return Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Email
                      BaseTextField(
                        controller: _emailController,
                        enabled: enableInputs,
                        labelText: 'email_label_text'.tr(),
                        helperText: 'email_helper_text'.tr(),
                        autoFocus: true,
                        validator: validateEmail,
                        errorText: state is ErrorRestorePasswordState ? unescape.convert(state.message) : null,
                        hasFocus: _focusNode.hasFocus,
                      ),
                      const SizedBox(height: 20.0),
                      AppElevatedButton.primary(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<RestorePasswordBloc>(context).add(
                              SendRestorePasswordEvent(
                                _emailController.text,
                              ),
                            );
                          }
                        },
                        child: state is LoadingRestorePasswordState
                            ? LoaderWidget()
                            : Text(
                                'restore_password_button'.tr(),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
