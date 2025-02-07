import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/services/local_notifications_service.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/presentation/screens/favorites/favorites_screen.dart';
import 'package:masterstudy_app/presentation/screens/home/home_screen.dart';
import 'package:masterstudy_app/presentation/screens/home_simple/home_simple_screen.dart';
import 'package:masterstudy_app/presentation/screens/profile/profile_screen.dart';
import 'package:masterstudy_app/presentation/screens/search/search_screen.dart';
import 'package:masterstudy_app/presentation/screens/user_courses/user_courses_screen.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({this.selectedIndex}) : super();

  static const String routeName = '/homeRoot';

  final int? selectedIndex;

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<HomeRoot> {
  int _selectedIndex = 0;

  LocalNotificationService localNotificationService = LocalNotificationService();

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;

      BlocProvider.of<NavigationBloc>(context).add(ChangeNavEvent(_selectedIndex));
    }

    FirebaseMessaging.onMessage.listen(localNotificationService.showNotification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NavigationBloc, NavigationState>(
            listener: (context, state) {
              if (state is ChangedNavigationState) {
                setState(() {
                  _selectedIndex = state.index;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is ChangedNavigationState) {
              switch (state.index) {
                case 0:
                  return appView ? HomeSimpleScreen() : HomeScreen();
                case 1:
                  return SearchScreen();
                case 2:
                  return UserCoursesScreen();
                case 3:
                  return FavoritesScreen();
                case 4:
                  if (!isAuth()) {
                    return AuthScreen();
                  } else {
                    return ProfileScreen();
                  }

                default:
                  return appView ? HomeSimpleScreen() : HomeScreen();
              }
            }
            return appView ? HomeSimpleScreen() : HomeScreen();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        selectedFontSize: 10,
        backgroundColor: ColorApp.bgColor,
        currentIndex: _selectedIndex,
        selectedItemColor: ColorApp.mainColor,
        unselectedItemColor: ColorApp.unselectedColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
          });

          context.read<NavigationBloc>().add(ChangeNavEvent(index));
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navHome, 0),
            label: 'home_bottom_nav'.tr(),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navCourses, 1),
            label: 'search_bottom_nav'.tr(),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navPlay, 2),
            label: 'courses_bottom_nav'.tr(),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navFavourites, 3),
            label: 'favorites_bottom_nav'.tr(),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navProfile, 4),
            label: 'profile_bottom_nav'.tr(),
          ),
        ],
      ),
    );
  }

  Color? _getItemColor(int index) => _selectedIndex == index ? ColorApp.mainColor : ColorApp.unselectedColor;

  Widget _buildIcon(String iconData, int index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SvgPicture.asset(
          iconData,
          height: 22.0,
          colorFilter: ColorFilter.mode(_getItemColor(index)!, BlendMode.srcIn),
        ),
      );
}
