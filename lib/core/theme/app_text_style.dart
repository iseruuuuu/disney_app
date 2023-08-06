import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  AppTextStyle._();

  static const cellNameTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const cellUserIdTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  //TODO 共通のStyleにする。
  static const cellAttractionTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.black,
  );

  //TODO 共通のStyleにする。
  static const cellDescriptionTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: Colors.black,
  );

  static const cellSpoilerDescriptionTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.red,
  );

  static const accountNameTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black,
  );
  static const accountUserIdTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.grey,
  );

  static const accountSelfIntroductionTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static const detailAccountNameTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle tweetTextStyle = GoogleFonts.pattaya(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const detailRankTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 23,
  );

  static const detailAttractionNameTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 19,
  );

  static const detailContentTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.black,
  );

  static TextStyle detailCreatedTimeTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.grey.shade600,
  );

  static const noPostTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  //TODO 共通のStyleにする。
  static const postTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static const labelTextStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );
  static const textFieldTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static TextStyle appBarCreateAccountTextStyle = GoogleFonts.pattaya(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const cancelTextStyle = TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );

  static const okTextStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );
}
