import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkeletonsLoading extends StatelessWidget {
  const AppSkeletonsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const AppSkeletonsCellLoading();
        },
      ),
    );
  }
}

class AppSkeletonsCellLoading extends StatelessWidget {
  const AppSkeletonsCellLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      child: Card(
        child: ListTile(
          leading: Icon(Icons.add, size: 70),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text('12345678910111213'),
              SizedBox(height: 10),
              Text('12345678910'),
              SizedBox(height: 20),
              Text('1234567891011121314151617181920'),
              SizedBox(height: 20),
              Text('1234567891011121314151617181920'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
