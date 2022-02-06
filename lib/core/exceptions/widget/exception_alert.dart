import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/exceptions/base_api_exception.dart';
import 'package:intersmeet/core/exceptions/exception_handler.dart';
import 'package:intersmeet/core/exceptions/variants/no_exception.dart';

import '../../../main.dart';

class ExceptionAlertWidget extends StatelessWidget {
  ExceptionAlertWidget({Key? key}) : super(key: key);
  final exceptionHandler = getIt<ExceptionHandler>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseApiException>(
      stream: exceptionHandler.suscribe(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final exception = snapshot.data;

          if (exception == null || exception is NoException) {
            return const SizedBox();
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context, exception),
          );
        }
        return const SizedBox();
      },
    );
  }

  contentBox(context, BaseApiException exception) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colorz.complexDrawerBlack,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.grey, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                exception.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                exception.message,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We're sorry you've encountered a bug!",
                style: TextStyle(fontSize: 17, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              ElevatedButton(
                  onPressed: () {
                    exceptionHandler.publishNull();
                  },
                  child: const Text(
                    "Close alert",
                    style: TextStyle(fontSize: 18),
                  )),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: Image.asset("assets/images/error.png")),
          ),
        ),
      ],
    );
  }
}
