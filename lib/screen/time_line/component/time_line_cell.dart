import 'package:disney_app/model/account.dart';
import 'package:disney_app/model/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineCell extends StatelessWidget {
  const TimeLineCell({
    Key? key,
    required this.index,
    required this.postAccount,
    required this.post,
  }) : super(key: key);

  final int index;
  final Account postAccount;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: index == 0
            ? const Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              )
            : const Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 30,
              foregroundImage: NetworkImage(postAccount.imagePath),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      postAccount.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      postAccount.userId,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('yyyy/MM/dd').format(
                      post.createdTime!.toDate(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(post.attractionName),
                  ),
                  Text('${post.rank}点'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
