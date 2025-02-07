import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/account/account.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/profile_edit/widgets/change_language_widget.dart';
import 'package:masterstudy_app/presentation/screens/profile_edit/widgets/change_password_screen.dart';
import 'package:masterstudy_app/presentation/screens/splash/splash_screen.dart';
import 'package:masterstudy_app/presentation/widgets/app_elevated_button.dart';
import 'package:masterstudy_app/presentation/widgets/base_text_field.dart';
import 'package:masterstudy_app/presentation/widgets/dialog_author.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class ProfileEditScreenArgs {
  ProfileEditScreenArgs(this.account);

  final Account? account;
}

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen() : super();

  static const String routeName = '/profileEditScreen';

  @override
  Widget build(BuildContext context) {
    ProfileEditScreenArgs? args = ModalRoute.of(context)?.settings.arguments as ProfileEditScreenArgs;
    return BlocProvider(
      create: (context) => EditProfileBloc()..account = args.account!,
      child: _ProfileEditWidget(
        account: args.account,
      ),
    );
  }
}

class _ProfileEditWidget extends StatefulWidget {
  const _ProfileEditWidget({Key? key, this.account}) : super(key: key);

  final Account? account;

  @override
  State<StatefulWidget> createState() => _ProfileEditWidgetState();
}

class _ProfileEditWidgetState extends State<_ProfileEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();

  bool enableInputs = true;
  bool passwordVisible = false;
  File? _imageFile;

  @override
  void initState() {
    passwordVisible = true;
    _firstNameController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.firstName;
    _lastNameController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.lastName;
    _emailController.text = BlocProvider.of<EditProfileBloc>(context).account.email!;
    _bioController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.description;
    _occupationController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.position;
    _facebookController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.facebook;
    _twitterController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.twitter;
    _instagramController.text = BlocProvider.of<EditProfileBloc>(context).account.meta!.instagram;
    _focusNode.dispose();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _occupationController.dispose();
    _passwordController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorApp.mainColor,
        centerTitle: true,
        title: Text(
          'edit_profile_title'.tr(),
          style: kAppBarTextStyle,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EditProfileBloc, EditProfileState>(
            listener: (context, state) {
              if (state is UpdatedEditProfileState) {
                showFlutterToast(
                  title: 'profile_updated_message'.tr(),
                );

                BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());
              }

              if (state is ErrorEditProfileState) {
                showFlutterToast(
                  title: state.message ?? 'Unknown error',
                );
              }

              if (state is CloseEditProfileState) {
                BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());

                showFlutterToast(
                  title: 'profile_change_canceled'.tr(),
                );
              }

              if (state is SuccessDeleteAccountState) {
                preferences.remove(PreferencesName.demoMode);
                BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SplashScreen.routeName,
                  (Route<dynamic> route) => false,
                );
              }

              if (state is ErrorDeleteAccountState) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'error_dialog_title'.tr(),
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        content: Text(
                          'error_dialog_title'.tr(),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            String userRole = '';

            enableInputs = !(state is LoadingEditProfileState);

            if (BlocProvider.of<EditProfileBloc>(context).account.roles!.isEmpty) {
              userRole = 'subscriber';
            } else {
              userRole = BlocProvider.of<EditProfileBloc>(context).account.roles![0];
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: CircleAvatar(
                                radius: 50.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    imageUrl: widget.account!.avatarUrl!,
                                    imageBuilder: (context, imageProvider) {
                                      if (_imageFile != null) {
                                        return Image.file(
                                          _imageFile!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        );
                                      }

                                      return Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    placeholder: (context, url) => LoaderWidget(
                                      loaderColor: ColorApp.white,
                                    ),
                                    errorWidget: (context, url, error) {
                                      return SizedBox(
                                        width: 100.0,
                                        child: Image.asset(IconPath.emptyUser),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            if (_imageFile != null && state is! UpdatedEditProfileState)
                              Positioned(
                                top: 10,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete_forever_outlined,
                                    color: ColorApp.lipstick,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Button "Change Photo"
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                                side: BorderSide(color: ColorApp.secondaryColor),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(ColorApp.secondaryColor),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
                          ),
                          onPressed: () async {
                            if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                              showDialogError(context, 'demo_mode'.tr());
                            } else {
                              XFile? image = await picker.pickImage(source: ImageSource.gallery);

                              if (image != null) {
                                setState(() {
                                  _imageFile = File(image.path);
                                });
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  child: SvgPicture.asset(
                                    IconPath.file,
                                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                  width: 23,
                                  height: 23,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  'change_photo_button'.tr(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // FirstName
                      BaseTextField(
                        controller: _firstNameController,
                        labelText: 'first_name'.tr(),
                        hasFocus: _focusNode.hasFocus,
                        enabled: enableInputs,
                        readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      ),
                      const SizedBox(height: 20.0),
                      // LastName
                      BaseTextField(
                        controller: _lastNameController,
                        labelText: 'last_name'.tr(),
                        hasFocus: _focusNode.hasFocus,
                        enabled: enableInputs,
                        readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                      ),
                      // Occupation
                      userRole != 'subscriber'
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: BaseTextField(
                                controller: _occupationController,
                                labelText: 'occupation'.tr(),
                                hasFocus: _focusNode.hasFocus,
                                enabled: enableInputs,
                                readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                              ),
                            )
                          : const SizedBox(
                              height: 20,
                            ),
                      // Email
                      BaseTextField(
                        controller: _emailController,
                        enabled: enableInputs,
                        validator: validateEmail,
                        hasFocus: _focusNode.hasFocus,
                        readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                        labelText: 'email_label_text'.tr(),
                        helperText: 'email_helper_text'.tr(),
                      ),
                      const SizedBox(height: 20.0),
                      // Bio
                      BaseTextField(
                        controller: _bioController,
                        enabled: enableInputs,
                        maxLines: 5,
                        readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                        textCapitalization: TextCapitalization.sentences,
                        labelText: 'bio'.tr(),
                        helperText: 'bio_helper'.tr(),
                        hasFocus: _focusNode.hasFocus,
                      ),
                      const SizedBox(height: 20.0),
                      // Facebook
                      BaseTextField(
                        controller: _facebookController,
                        enabled: enableInputs,
                        readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                        labelText: 'Facebook',
                        hintText: 'enter_url'.tr(),
                        hasFocus: _focusNode.hasFocus,
                      ),
                      const SizedBox(height: 20.0),
                      // Twitter
                      BaseTextField(
                        controller: _twitterController,
                        enabled: enableInputs,
                        readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                        labelText: 'Twitter',
                        hintText: 'enter_url'.tr(),
                        hasFocus: _focusNode.hasFocus,
                      ),
                      const SizedBox(height: 20.0),
                      // Instagram
                      BaseTextField(
                        controller: _instagramController,
                        enabled: enableInputs,
                        readOnly: preferences.getBool(PreferencesName.demoMode) ?? false,
                        labelText: 'Instagram',
                        hintText: 'enter_url'.tr(),
                        hasFocus: _focusNode.hasFocus,
                      ),
                      const SizedBox(height: 20.0),
                      // Languages
                      ChangeLanguageWidget(),
                      const SizedBox(height: 30.0),
                      // Button Save
                      AppElevatedButton.primary(
                        onPressed: state is LoadingEditProfileState
                            ? null
                            : () {
                                if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                                  showDialogError(context, 'demo_mode'.tr());
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<EditProfileBloc>(context).add(
                                      SaveEvent(
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        password: _passwordController.text,
                                        description: _bioController.text,
                                        position: _occupationController.text,
                                        facebook: _facebookController.text,
                                        twitter: _twitterController.text,
                                        instagram: _instagramController.text,
                                        photo: _imageFile,
                                      ),
                                    );
                                  }
                                }
                              },
                        child: state is LoadingEditProfileState
                            ? LoaderWidget()
                            : Text(
                                'save_button'.tr(),
                              ),
                      ),
                      const SizedBox(height: 10.0),
                      // Button Change Password
                      AppElevatedButton.primary(
                        onPressed: () {
                          if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                            showDialogError(context, 'demo_mode'.tr());
                          } else {
                            Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
                          }
                        },
                        child: Text(
                          'change_password'.tr().toUpperCase(),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Button Delete Account
                      AppElevatedButton.error(
                        onPressed: () {
                          if (preferences.getBool(PreferencesName.demoMode) ?? false) {
                            showDialogError(context, 'demo_mode'.tr());
                          } else {
                            _showDeleteAccountDialog(context, state);
                          }
                        },
                        child: Text(
                          'delete_account'.tr().toUpperCase(),
                        ),
                      ),
                      // Cancel button
                      TextButton(
                        child: Text(
                          'cancel_button'.tr(),
                          style: TextStyle(color: ColorApp.mainColor),
                        ),
                        onPressed: () => BlocProvider.of<EditProfileBloc>(context).add(CloseScreenEvent()),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showDeleteAccountDialog(BuildContext context, EditProfileState state) {
    AlertDialog alert = AlertDialog(
      title: Text(
        'delete_account'.tr(),
        style: TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      content: Text(
        'delete_account_subscription'.tr(),
      ),
      actions: [
        TextButton(
          child: Text(
            'cancel_button'.tr(),
            style: TextStyle(
              color: ColorApp.mainColor,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: state is LoadingDeleteAccountState
              ? LoaderWidget()
              : Text(
                  'delete_account'.tr(),
                  style: TextStyle(color: ColorApp.mainColor),
                ),
          onPressed: state is LoadingDeleteAccountState
              ? null
              : () {
                  BlocProvider.of<EditProfileBloc>(context)
                      .add(DeleteAccountEvent(accountId: int.parse(widget.account!.id.toString())));
                },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
