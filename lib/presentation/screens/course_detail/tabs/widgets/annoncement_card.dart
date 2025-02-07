import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class AnnoncementCard extends StatefulWidget {
  const AnnoncementCard({Key? key, this.annoncementUrl}) : super(key: key);

  final String? annoncementUrl;

  @override
  State<AnnoncementCard> createState() => _AnnoncementCardState();
}

class _AnnoncementCardState extends State<AnnoncementCard> {
  InAppWebViewController? webViewController;

  bool showMore = false;

  /// Height of annoncement content
  double? contentHeight;

  double defaultHeight = 160.0;

  @override
  Widget build(BuildContext context) {
    double webContainerHeight;

    if (contentHeight != null && showMore) {
      webContainerHeight = contentHeight!;
    } else {
      webContainerHeight = 160;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'annoncement_title'.tr(),
            style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                  color: ColorApp.dark,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: webContainerHeight,
          ),
          child: InAppWebView(
            initialData: InAppWebViewInitialData(data: widget.annoncementUrl!),
            onLoadStop: (InAppWebViewController controller, Uri? uri) async {
              int? height = await controller.getContentHeight();
              double? zoomScale = await controller.getZoomScale();
              double htmlHeight = height!.toDouble() * zoomScale!;
              double htmlHeightFixed = double.parse(htmlHeight.toStringAsFixed(2));
              if (htmlHeightFixed == 0.0) {
                return;
              }
              setState(() {
                contentHeight = htmlHeightFixed + 0.1;
              });
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              ),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  showMore = !showMore;
                });
              },
              child: Text(
                showMore ? 'show_less_button'.tr() : 'show_more_button'.tr(),
                style: TextStyle(color: ColorApp.mainColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
