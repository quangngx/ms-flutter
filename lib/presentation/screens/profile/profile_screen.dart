import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/presentation/screens/orders/orders_screen.dart';
import 'package:masterstudy_app/presentation/screens/profile/widgets/profile_widget.dart';
import 'package:masterstudy_app/presentation/screens/profile/widgets/tile_widget.dart';
import 'package:masterstudy_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/presentation/widgets/unauthorized_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen() : super();

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // if (BlocProvider.of<ProfileBloc>(context).state is! LoadedProfileState) {
    BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LogoutProfileState) {
          Navigator.of(context).pop();

          context.read<NavigationBloc>().add(ChangeNavEvent(4));
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          if (state is InitialProfileState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is UnauthorizedState) {
            return UnauthorizedWidget(
              onTap: () => context.read<NavigationBloc>().add(ChangeNavEvent(4)),
            );
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: ColorApp.mainColor,
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    // Header Profile
                    ProfileWidget(),

                    // Divider
                    Divider(
                      height: 0.0,
                      thickness: 1.0,
                      color: Color(0xFFE5E5E5),
                    ),

                    // View my profile
                    TileWidget(
                      title: 'view_my_profile'.tr(),
                      assetPath: IconPath.profileIcon,
                      onTap: () {
                        if (state is LoadedProfileState)
                          Navigator.pushNamed(
                            context,
                            DetailProfileScreen.routeName,
                            arguments: DetailProfileScreenArgs(),
                          );
                      },
                    ),

                    if (!isFree)
                      // My orders
                      TileWidget(
                        title: 'my_orders'.tr(),
                        assetPath: IconPath.orders,
                        onTap: () => Navigator.of(context).pushNamed(OrdersScreen.routeName),
                      ),

                    // My courses
                    TileWidget(
                      title: 'my_courses'.tr(),
                      assetPath: IconPath.navCourses,
                      onTap: () => context.read<NavigationBloc>().add(ChangeNavEvent(2)),
                    ),

                    // Settings
                    TileWidget(
                      title: 'settings'.tr(),
                      assetPath: IconPath.settings,
                      onTap: () {
                        if (state is LoadedProfileState) {
                          Navigator.pushNamed(
                            context,
                            ProfileEditScreen.routeName,
                            arguments: ProfileEditScreenArgs(state.account),
                          );
                        }
                      },
                    ),

                    // Logout
                    TileWidget(
                      title: 'logout'.tr(),
                      assetPath: IconPath.logout,
                      onTap: () => _showLogoutDialog(context),
                      textColor: ColorApp.lipstick,
                      iconColor: ColorApp.lipstick,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'logout'.tr(),
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          content: Text(
            'logout_message'.tr(),
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
              child: Text(
                'logout'.tr(),
                style: TextStyle(color: ColorApp.mainColor),
              ),
              onPressed: () {
                GoogleSignInProvider().logoutGoogle();
                BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
