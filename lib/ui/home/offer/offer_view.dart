// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/models/degree/company.dart';
import 'package:intersmeet/core/models/offer/application.dart';
import 'package:intersmeet/core/models/offer/offer.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/home/home_scaffold.dart';
import 'package:intersmeet/ui/shared/br.dart';
import 'package:intersmeet/ui/shared/gradient_button.dart';
import 'package:intersmeet/ui/shared/text_utils.dart';

class OfferViewArguments {
  final Offer offer;
  final Status? status;
  final void Function(Status status)? onStatusChange;

  OfferViewArguments({required this.offer, this.status, this.onStatusChange});
}

class OfferView extends StatefulWidget {
  final String? message;
  const OfferView({Key? key, this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  final userService = getIt<UserService>();
  final authService = getIt<UserService>();

  void Function(Status status)? onStatusChange;
  Offer? offer;
  Company? company;
  Status? status;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final OfferViewArguments args =
          ModalRoute.of(context)!.settings.arguments as OfferViewArguments;
      offer = args.offer;
      status = args.status;
      _asyncInitState(args.offer);
      onStatusChange = args.onStatusChange;
    });
    super.initState();
  }

  void _asyncInitState(Offer offer) async {
    var companies = await userService.findAllCompanies();
    setState(() {
      company = companies.firstWhere((comp) => comp.companyId == offer.companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // @ Build UI
    return HomeScaffold(
      title: Text(offer?.name ?? ''),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                br(25),
                _applicationsCard(),
                br(25),
                offer != null
                    ? GradientButton(
                        disabled: offer!.deadLine.isBefore(DateTime.now()),
                        text: status == null || status == Status.canceled
                            ? offer!.deadLine.isBefore(DateTime.now())
                                ? "You can't apply to an expired offer"
                                : "Apply now"
                            : "Cancel application",
                        onPressed: () async {
                          if (status == null || status == Status.canceled) {
                            _apply();
                          } else {
                            _cancel();
                          }
                        },
                        color1: const Color(0xff2C2E41),
                        color2: const Color(0xff0A0B0F),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _apply() async {
    await userService.createApplication(offer!.offerId);

    setState(() {
      status = Status.inProgress;
    });
    if (onStatusChange != null) {
      onStatusChange!(Status.inProgress);
    }
  }

  void _cancel() async {
    await userService.cancelApplication(offer!.offerId);

    setState(() {
      status = Status.canceled;
    });
    if (onStatusChange != null) {
      onStatusChange!(Status.canceled);
    }
  }

  Widget _applicationsCard() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Card(
        shadowColor: Colors.white,
        color: Colorz.richCalculatorInnerButtonColor,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: offer != null && company != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    br(13),
                    _offerDetail(title: "Company", content: company!.companyName),
                    br(20),
                    RichText(
                      text: const TextSpan(
                        text: 'Description:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colorz.accountPurpleLight,
                        ),
                      ),
                    ),
                    br(3),
                    Text(
                      offer!.description,
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey[300],
                      ),
                      maxLines: 12,
                    ),
                    br(10),
                    _offerDetail(
                      title: "Deadline",
                      content: dateToString(offer!.deadLine),
                      contentFontSize: 15,
                    ),
                    br(10),
                    _offerDetail(
                      title: "Salary",
                      content: '${offer!.salary} €/m',
                      contentFontSize: 15,
                    ),
                    offer?.schedule != null
                        ? _offerDetail(
                            title: "Schedule",
                            content: offer!.schedule!,
                            contentFontSize: 15,
                          )
                        : const SizedBox(),
                    br(10),
                    _offerDetail(
                      title: "Applicants",
                      content: '${offer!.applicantCount}',
                      contentFontSize: 15,
                    ),
                    br(10),
                    status != null
                        ? Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Status:  ',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colorz.accountPurpleLight,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${statusValue(status!)}  ',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              statusIcon(status)
                            ],
                          )
                        : const SizedBox(),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget _offerDetail({
    required String title,
    required String content,
    double titleFontSize = 18,
    double contentFontSize = 18,
  }) {
    return RichText(
      text: TextSpan(
        text: '$title:  ',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.w700,
          color: Colorz.accountPurpleLight,
        ),
        children: [
          TextSpan(
            text: content,
            style: TextStyle(
              color: Colors.white,
              fontSize: contentFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
