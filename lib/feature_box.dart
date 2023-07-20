import 'package:flutter/material.dart';
import 'package:snicker_bot/pallete.dart';

class FeatureBox extends StatelessWidget {
  final String headerText;
  final String descriptionText;
  final Color color;
  const FeatureBox(
      {required this.headerText,
      required this.descriptionText,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 35,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: TextStyle(
                  fontFamily: 'San Francisco',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Pallete.blackColor,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
              ),
              child: Text(
                descriptionText,
                style: TextStyle(
                  fontFamily: 'San Francisco',
                  color: Pallete.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
