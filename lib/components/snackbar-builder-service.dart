import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flushbar/flushbar.dart';

class SnackbarBuilderService {
  static Flushbar buildFlushBar(FlushBarConfiguration config) {
    return Flushbar(
      title: config.title,
      message: config.message,
      titleText: config.titleTextStyled,
      messageText: config.messageTextStyled,
      flushbarPosition: config.position,
      reverseAnimationCurve: config.reverseAnimationCurve,
      forwardAnimationCurve: config.forwardAnimationCurve,
      backgroundColor: config.backgroundColor,
      shadowColor: config.shadowColor,
      backgroundGradient: config.backgroundGradient,
      isDismissible: config.isDismissable,
      duration: config.duration,
      icon: config.icon,
      mainButton: config.mainButton,
    );
  }
}

class FlushBarConfiguration {
  String title;
  String message;
  Text titleTextStyled;
  Text messageTextStyled;
  FlushbarPosition position;
  Curve reverseAnimationCurve;
  Curve forwardAnimationCurve;
  Color backgroundColor;
  Color shadowColor;
  LinearGradient backgroundGradient;
  bool isDismissable;
  Duration duration;
  Icon icon;
  FlatButton mainButton;

  FlushBarConfiguration(this.title, this.message, this.isDismissable, this.duration,
    { TextStyle titleStyle, TextStyle messageStyle, Icon icon, FlatButton mainBtn,
      FlushbarPosition pos = FlushbarPosition.BOTTOM, Curve reverseAnimCurve = Curves.decelerate,
      Curve forwardAnimCurve = Curves.elasticOut, Color backgroundColor, Color shadowColor,
      LinearGradient backgroundGradient}) 
  {
    titleTextStyled = (titleStyle != null) ? Text(title, style: titleStyle) : null;
    messageTextStyled = (messageStyle != null) ? Text(title, style: messageStyle) : null;
    icon = icon;
    mainButton = mainBtn;
    position = pos;
    reverseAnimationCurve = reverseAnimCurve;
    forwardAnimationCurve = forwardAnimCurve;
    backgroundColor = backgroundColor;
    shadowColor = shadowColor;
    backgroundGradient = backgroundGradient;
  }

}