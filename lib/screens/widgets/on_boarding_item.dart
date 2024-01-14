import 'package:flutter/material.dart';
import 'package:salla/models/on_boarding_model.dart';

class OnBoardingItem extends StatelessWidget {
  const OnBoardingItem({
    super.key,
    required this.onBoardingModel,
  });

  final OnBoardingModel onBoardingModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image.asset(
            onBoardingModel.imgPath,
          ),
        ),
        const SizedBox(
          height: 40, // Adjust the spacing between image and title
        ),
        Text(
          onBoardingModel.title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        const SizedBox(
          height: 25, // Adjust the spacing between title and body
        ),
        Text(
          onBoardingModel.body,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 19,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 200,
        ),
      ],
    );
  }
}
