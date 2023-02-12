import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  const PostButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(),
        onPressed: onPressed,
        child: const Text('投稿'),
      ),
    );
  }
}
