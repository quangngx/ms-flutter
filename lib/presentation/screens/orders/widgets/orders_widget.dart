import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/presentation/bloc/orders/orders_bloc.dart';
import 'package:masterstudy_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:masterstudy_app/presentation/widgets/empty_widget.dart';
import 'package:masterstudy_app/presentation/widgets/error_widget.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:transparent_image/transparent_image.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  void initState() {
    BlocProvider.of<OrdersBloc>(context).add(LoadOrdersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        List<OrderBean?> orders = [];

        if (state is LoadingOrdersState) {
          return LoaderWidget();
        }

        if (state is EmptyOrdersState) {
          return EmptyWidget(
            imgIcon: IconPath.emptyCourses,
            title: 'no_user_orders_screen_title'.tr(),
          );
        }

        if (state is LoadedOrdersState) {
          orders = state.orders;
        }

        if (state is ErrorOrdersState) {
          return ErrorCustomWidget(
            message: state.message ?? 'unknown_error'.tr(),
            onTap: () => BlocProvider.of<OrdersBloc>(context).add(LoadOrdersEvent()),
          );
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext ctx, int index) {
            return OrderWidget(
              orders[index],
              index == 0,
            );
          },
        );
      },
    );
  }
}

class OrderWidget extends StatefulWidget {
  OrderWidget(this.orderBean, this.opened) : super();

  final OrderBean? orderBean;
  final bool opened;

  @override
  State<StatefulWidget> createState() => OrderWidgetState();
}

class OrderWidgetState extends State<OrderWidget> {
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
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${widget.orderBean!.dateFormatted}  id:${widget.orderBean!.id}',
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
                      itemCount: widget.orderBean!.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.orderBean?.cartItems[index];

                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              CourseScreen.routeName,
                              arguments: CourseScreenArgs.fromOrderListBean(item),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FadeInImage.memoryNetwork(
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 100,
                                      placeholder: kTransparentImage,
                                      image: item!.imageUrl,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          item.title,
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            item.priceFormatted,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'Status: ${widget.orderBean!.status}',
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          widget.orderBean!.orderKey,
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
