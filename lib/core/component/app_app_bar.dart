import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget {
  const AppAppBar({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  final String image;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 110,
          color: Colors.grey.shade300,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: text,
          leading: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
