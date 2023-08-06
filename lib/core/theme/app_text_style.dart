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

  static const cellAttractionTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.black,
  );

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
}
