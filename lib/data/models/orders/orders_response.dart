import 'package:json_annotation/json_annotation.dart';

part 'orders_response.g.dart';

@JsonSerializable()
class OrdersResponse {
  OrdersResponse({
    required this.posts,
    required this.memberships,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => _$OrdersResponseFromJson(json);

  final List<OrderBean?> posts;
  final List<MembershipBean?> memberships;

  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}

@JsonSerializable()
class OrderBean {
  OrderBean({
    required this.userId,
    required this.items,
    required this.date,
    required this.status,
    required this.paymentCode,
    required this.orderKey,
    required this.orderTotal,
    required this.orderCurrency,
    required this.i18n,
    required this.id,
    required this.dateFormatted,
    required this.cartItems,
    required this.total,
    required this.user,
  });

  factory OrderBean.fromJson(Map<String, dynamic> json) => _$OrderBeanFromJson(json);

  @JsonKey(name: 'user_id')
  final String userId;
  final List<ItemsBean?> items;
  final String date;
  final String status;
  @JsonKey(name: 'payment_code')
  final String paymentCode;
  @JsonKey(name: 'order_key')
  final String orderKey;
  @JsonKey(name: '_order_total')
  final String orderTotal;
  @JsonKey(name: '_order_currency')
  final String orderCurrency;
  final I18nBean? i18n;
  final num id;
  @JsonKey(name: 'date_formatted')
  final String dateFormatted;
  @JsonKey(name: 'cart_items')
  final List<CartItemsBean?> cartItems;
  final String total;
  final UserBean? user;

  Map<String, dynamic> toJson() => _$OrderBeanToJson(this);
}

@JsonSerializable()
class UserBean {
  UserBean({
    required this.id,
    required this.login,
    required this.avatar,
    required this.avatarUrl,
    required this.email,
    required this.url,
  });

  factory UserBean.fromJson(Map<String, dynamic> json) => _$UserBeanFromJson(json);

  final num id;
  final String login;
  final String avatar;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  final String email;
  final String url;

  Map<String, dynamic> toJson() => _$UserBeanToJson(this);
}

@JsonSerializable()
class CartItemsBean {
  CartItemsBean({
    required this.cartItemId,
    required this.title,
    required this.image,
    required this.status,
    this.price,
    required this.terms,
    required this.priceFormatted,
    required this.imageUrl,
  });

  factory CartItemsBean.fromJson(Map<String, dynamic> json) => _$CartItemsBeanFromJson(json);

  @JsonKey(name: 'cart_item_id')
  final int cartItemId;
  final String title;
  final String image;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String status;
  dynamic price;
  final List<String?> terms;
  @JsonKey(name: 'price_formatted')
  final String priceFormatted;

  Map<String, dynamic> toJson() => _$CartItemsBeanToJson(this);
}

@JsonSerializable()
class I18nBean {
  I18nBean({
    required this.orderKey,
    required this.date,
    required this.status,
    required this.pending,
    required this.processing,
    required this.failed,
    required this.onHold,
    required this.refunded,
    required this.completed,
    required this.cancelled,
    required this.user,
    required this.orderItems,
    required this.courseName,
    required this.coursePrice,
    required this.total,
  });

  factory I18nBean.fromJson(Map<String, dynamic> json) => _$I18nBeanFromJson(json);

  @JsonKey(name: 'order_key')
  final String orderKey;
  final String date;
  final String status;
  final String pending;
  final String processing;
  final String failed;
  @JsonKey(name: 'on-hold')
  final String onHold;
  final String refunded;
  final String completed;
  final String cancelled;
  final String user;
  @JsonKey(name: 'order_items')
  final String orderItems;
  @JsonKey(name: 'course_name')
  final String courseName;
  @JsonKey(name: 'course_price')
  final String coursePrice;
  final String total;

  Map<String, dynamic> toJson() => _$I18nBeanToJson(this);
}

@JsonSerializable()
class ItemsBean {
  ItemsBean({required this.itemId, required this.price});

  factory ItemsBean.fromJson(Map<String, dynamic> json) => _$ItemsBeanFromJson(json);
  @JsonKey(name: 'item_id')
  final String itemId;
  final String price;

  Map<String, dynamic> toJson() => _$ItemsBeanToJson(this);
}

@JsonSerializable()
class MembershipBean {
  MembershipBean({
    required this.ID,
    required this.id,
    required this.subscriptionId,
    required this.name,
    required this.description,
    required this.confirmation,
    required this.expirationNumber,
    required this.expirationPeriod,
    required this.initialPayment,
    required this.billingAmount,
    required this.cycleNumber,
    required this.cyclePeriod,
    required this.billingLimit,
    required this.trialAmount,
    required this.trialLimit,
    required this.codeId,
    required this.startDate,
    required this.endDate,
    required this.courseNumber,
    required this.usedQuotas,
    required this.quotasLeft,
    required this.button,
    required this.features,
    required this.status,
  });

  factory MembershipBean.fromJson(Map<String, dynamic> json) => _$MembershipBeanFromJson(json);

  final String ID;
  final String id;
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;
  final String name;
  final String description;
  final String confirmation;
  @JsonKey(name: 'expiration_number')
  final String expirationNumber;
  @JsonKey(name: 'expiration_period')
  final String expirationPeriod;
  @JsonKey(name: 'initial_payment')
  final num initialPayment;
  @JsonKey(name: 'billing_amount')
  final num billingAmount;
  @JsonKey(name: 'cycle_number')
  final String cycleNumber;
  @JsonKey(name: 'cycle_period')
  final String cyclePeriod;
  @JsonKey(name: 'billing_limit')
  final String billingLimit;
  @JsonKey(name: 'trial_amount')
  final num trialAmount;
  @JsonKey(name: 'trial_limit')
  final String trialLimit;
  @JsonKey(name: 'code_id')
  final String codeId;
  @JsonKey(name: 'startdate')
  final String startDate;
  @JsonKey(name: 'enddate')
  final String endDate;
  @JsonKey(name: 'course_number')
  final String courseNumber;
  final String features;
  @JsonKey(name: 'used_quotas')
  final num usedQuotas;
  @JsonKey(name: 'quotas_left')
  final num quotasLeft;
  final ButtonBean? button;
  final String status;

  Map<String, dynamic> toJson() => _$MembershipBeanToJson(this);
}

@JsonSerializable()
class ButtonBean {
  ButtonBean({required this.text, required this.url});

  factory ButtonBean.fromJson(Map<String, dynamic> json) => _$ButtonBeanFromJson(json);
  final String text;
  final String url;

  Map<String, dynamic> toJson() => _$ButtonBeanToJson(this);
}
