import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/models/offer/application.dart';
import 'package:intersmeet/core/models/offer/offer.dart';
import 'package:intersmeet/ui/home/offer/offer_view.dart';
import 'package:intersmeet/ui/shared/br.dart';
import 'package:intersmeet/ui/shared/text_utils.dart';

class AplicationsItemComponent extends StatelessWidget {
  final Application application;
  final Color background;
  final bool showIsExpired;

  const AplicationsItemComponent({
    Key? key,
    required this.application,
    required this.background,
    this.showIsExpired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      child: InkWell(
        onTap: () => {
          Navigator.of(context).pushNamed(
            'offer',
            arguments: OfferViewArguments(
              offer: Offer.fromApplication(application),
              status: application.status,
              onStatusChange: (status) => application.status = status,
            ),
          )
        },
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
          height: 115,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            '${application.name} - ${application.offerId}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        showIsExpired
                            ? application.deadLine.isBefore(DateTime.now())
                                ? Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: const Text(
                                      'Expired',
                                      style: TextStyle(color: Colors.redAccent, fontSize: 17),
                                    ),
                                  )
                                : const SizedBox()
                            : const SizedBox(),
                      ],
                    ),
                    const Divider(color: Color(0xFF30363D)),
                    Text(
                      application.description,
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey[300],
                      ),
                      maxLines: 2,
                    ),
                    br(5),
                    _offerDetail(title: 'Salary', content: '${application.salary}'),
                    br(4),
                    _offerDetail(title: 'Deadline', content: dateToString(application.deadLine)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: statusIcon(application.status),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offerDetail({required String title, required String content}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$title: ',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colorz.accountPurple,
        ),
        children: [
          TextSpan(
            text: content,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
