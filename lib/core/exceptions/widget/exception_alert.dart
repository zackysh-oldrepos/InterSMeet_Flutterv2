import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intersmeet/core/exceptions/base_api_exception.dart';
import 'package:intersmeet/core/exceptions/exception_handler.dart';

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
          if (exception != null) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context, exception),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  contentBox(context, BaseApiException exception) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                exception.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                exception.message,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      exception.message,
                      style: const TextStyle(fontSize: 18),
                    )),
              ),
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
                child: Image.asset("assets/model.jpeg")),
          ),
        ),
      ],
    );
  }
}
