import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class MembershipWidget extends StatefulWidget {
  const MembershipWidget({super.key});

  @override
  State<MembershipWidget> createState() => _MembershipWidgetState();
}

class _MembershipWidgetState extends State<MembershipWidget> {
  @override
  void initState() {
    BlocProvider.of<OrdersBloc>(context).add(LoadMembershipEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        List<MembershipBean?> memberships = [];

        if (state is LoadingMembershipState) {
          return LoaderWidget();
        }

        if (state is EmptyMembershipsState) {
          return EmptyWidget(
            imgIcon: IconPath.emptyCourses,
            title: 'no_user_orders_screen_title'.tr(),
          );
        }

        if (state is LoadedMembershipState) {
          memberships = state.memberships;
        }

        if (state is ErrorMembershipState) {
          return ErrorCustomWidget(
            message: state.message ?? 'unknown_error'.tr(),
            onTap: () => BlocProvider.of<OrdersBloc>(context).add(LoadMembershipEvent()),
          );
        }

        return ListView.builder(
          itemCount: memberships.length,
          itemBuilder: (BuildContext ctx, int index) {
            return MembershipCardWidget(memberships[index], index == 0);
          },
        );
      },
    );
  }
}

class MembershipCardWidget extends StatefulWidget {
  MembershipCardWidget(this.membershipsBean, this.opened) : super();

  final MembershipBean? membershipsBean;

  final bool opened;

  @override
  State<MembershipCardWidget> createState() => _MembershipCardWidgetState();
}

class _MembershipCardWidgetState extends State<MembershipCardWidget> {
  bool expanded = false;

  @override
  void initState() {
    expanded = widget.opened;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'StartDate: ${widget.membershipsBean!.startDate}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        icon: Icon(
                          expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: ColorApp.mainColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'EndDate: ${widget.membershipsBean!.endDate.toString()}',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Visibility(
                visible: expanded,
                child: Column(
                  children: <Widget>[
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) => Divider(
                        height: 3,
                        thickness: 0.5,
                        color: Color(0xFF707070),
                      ),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        final item = widget.membershipsBean;
                        final regExpHtml = RegExp('.*\\<[^>]+>.*');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${item!.name}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            regExpHtml.hasMatch(item.description)
                                ? Text(
                                    'Description:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  )
                                : const SizedBox(),
                            regExpHtml.hasMatch(item.description)
                                ? Html(
                                    data: item.description,
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize(14),
                                      ),
                                    },
                                  )
                                : Text(
                                    'Description: ${item.description}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                            const SizedBox(height: 8),
                            Text(
                              'Cycle Period: ${item.cyclePeriod}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Initial payment: ${item.initialPayment}\$',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Billing amount: ${item.billingAmount}\$',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${item.status}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          '#${widget.membershipsBean!.subscriptionId}',
                          style: TextStyle(color: Color(0xFF999999), fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
