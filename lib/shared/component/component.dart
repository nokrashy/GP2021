//import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';

Widget defulteButton({
  background = Colors.blue,
  width = double.infinity,
  bool isUpperCase = true,
  double radius = 20.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  GestureTapCallback? onTap,
  required FormFieldValidator<String>? validate,
  required String lable,
  required IconData prefix,
  IconData? suffix,
  bool obsCuretext = false,
  bool isCleckable = true,
  VoidCallback? onPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obsCuretext,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      onChanged: onChange,
      validator: validate,
      enabled: isCleckable,
      decoration: InputDecoration(
        hintText: lable,
        labelText: lable,
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            suffix,
          ),
        ),
      ),
    );

Widget defultTextButton({
  required VoidCallback? onPressed,
  required String text,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text.toUpperCase(),
    ),
  );
}

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  String title = '',
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          IconBroken.Arrow___Left_2,
        ),
      ),
      titleSpacing: 5.0,
      title: Text(
        title,
      ),
      actions: actions,
    );

Widget MyDivider() {
  return Padding(
    padding: const EdgeInsetsDirectional.only(
      start: 15.0,
      end: 15.0,
    ),
    child: Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
  );
}

void NavigetTo(context, Widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
    );
    

void NavidetAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => Widget), (route) => false);

void showToast({
  required String msg,
  required toastStates state,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum toastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(toastStates states) {
  Color color;
  switch (states) {
    case toastStates.SUCCESS:
      color = Colors.green;
      break;
    case toastStates.ERROR:
      color = Colors.red;
      break;
    case toastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

//***************** */
enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}
Widget InfoCard({
  final String? title,
  final String? content,
  final IconData? icon,
  final bool isPrimaryColor = true,
  required BuildContext context,
}) {
  final textTheme = isPrimaryColor
      ? Theme.of(context).primaryTextTheme
      : Theme.of(context).textTheme;
  return Card(
    elevation: 2,
    color: isPrimaryColor
        ? Theme.of(context).primaryColor
        : Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${title}',
            style: textTheme.headline6!.apply(fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 10),
          Text(
            '${content}',
            style: textTheme.subtitle2,
          ),
          const Spacer(),
          Icon(
            icon,
            size: 32,
            color: textTheme.subtitle2!.color,
          ),
        ],
      ),
    ),
  );
}

Widget itembuilder({var value, String? date, String? time}) {
  return Container(
    width: double.infinity,
    height: 75.0,
    child: Padding(
      padding: const EdgeInsets.only(
        right: 10.0,
        left: 10.0,
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${value}',
                // (value.isNaN) ? '' : '${value.round()}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                date!,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                time!,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget tempitembuilder({var value, String? date, String? time}) {
  return Container(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          '${value}',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          date!,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          time!,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}

/// Print Long String
void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}
