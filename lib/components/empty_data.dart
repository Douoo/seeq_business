import 'package:flutter/material.dart';

import '../utils/constants.dart';

class EmptyData extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  const EmptyData({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(image),
            ),
            Container(
              width: 300,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: '$title\n\n',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                    TextSpan(
                      text: description,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
