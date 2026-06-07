import 'package:flutter/material.dart';
import 'package:uni_pay/src/utils/extension/size_extension.dart';
import 'package:uni_pay/src/views/widgets/payment_options_widget.dart';
import 'package:uni_pay/uni_pay.dart';

import '../../../../constant/uni_text.dart';

class TabbySplitPlanWidget extends StatelessWidget {
  final WidgetData widgetData;
  final TabbySessionData tabbySession;

  const TabbySplitPlanWidget(
      {Key? key, required this.widgetData, required this.tabbySession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSizes.init(context);
    UniPayText.isEnglish = widgetData.locale.isEnglish;
    return UniPaymentOptionWidget(
      title: UniPayText.tabbySplitBill,
      subTitle: "",
      image: "tabby",
      currentStatus:
          tabbySession.isPreScorePassed && tabbySession.rejectionReason == null
              ? widgetData.currentStatus
              : false,
      onChange:
          tabbySession.isPreScorePassed && tabbySession.rejectionReason == null
              ? widgetData.onChange
              : null,
      activeColor: widgetData.activeColor,
      uniPayPaymentMethods: UniPayPaymentMethods.tabby,
      subTitleWidget:
          tabbySession.isPreScorePassed && tabbySession.rejectionReason == null
              ? Text(UniPayText.useAnyCard)
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Text(UniPayText.tabbyRejectionTranslation(
                    tabbySession.rejectionReason!,
                  )),
                ),
    );
  }
}
