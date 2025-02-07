import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:masterstudy_app/presentation/screens/orders/widgets/membership_widget.dart';
import 'package:masterstudy_app/presentation/screens/orders/widgets/orders_widget.dart';
import 'package:masterstudy_app/presentation/widgets/colored_tabbar_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_styles.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const String routeName = '/ordersScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xFFF3F5F9),
          appBar: AppBar(
            backgroundColor: ColorApp.mainColor,
            centerTitle: true,
            title: Text(
              'user_orders_title'.tr(),
              style: kAppBarTextStyle,
            ),
            bottom: ColoredTabBar(
              Colors.white,
              TabBar(
                indicatorColor: ColorApp.secondaryColor,
                tabs: [
                  Tab(
                    text: 'one_time_payment'.tr(),
                  ),
                  Tab(
                    text: 'membership'.tr(),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
              child: TabBarView(
                children: <Widget>[
                  // OneTimePayment
                  BlocProvider.value(
                    value: OrdersBloc(),
                    child: OrdersWidget(),
                  ),
                  // Memberships
                  BlocProvider.value(
                    value: OrdersBloc(),
                    child: MembershipWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
