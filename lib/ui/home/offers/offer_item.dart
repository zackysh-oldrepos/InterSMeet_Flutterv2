import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/models/offer/application.dart';
import 'package:intersmeet/core/models/offer/offer.dart';
import 'package:intersmeet/ui/home/offer/offer_view.dart';
import 'package:intersmeet/ui/shared/br.dart';
import 'package:intersmeet/ui/shared/text_utils.dart';

class OffersItemComponent extends StatelessWidget {
  final Offer offer;
  final Color background;
  final bool showIsExpired;
  final Status? status;

  const OffersItemComponent({
    Key? key,
    required this.offer,
    required this.background,
    this.showIsExpired = true,
    this.status,
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
              offer: offer,
              status: status,
              onStatusChange: (Status? status) {
                status = status;
              },
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
                            '${offer.name} - ${offer.offerId}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        showIsExpired
                            ? offer.deadLine.isBefore(DateTime.now())
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
                      offer.description,
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey[300],
                      ),
                      maxLines: 2,
                    ),
                    br(5),
                    _offerDetail(title: 'Salary', content: '${offer.salary}'),
                    br(4),
                    _offerDetail(title: 'Deadline', content: dateToString(offer.deadLine)),
                  ],
                ),
              ),
              status != null
                  ? Expanded(
                      flex: 1,
                      child: statusIcon(status),
                    )
                  : const SizedBox()
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
