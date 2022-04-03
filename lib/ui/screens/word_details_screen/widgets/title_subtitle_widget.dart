import 'package:flutter/material.dart';

class TitleSubtitleWidget extends StatelessWidget {
  const TitleSubtitleWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.titleTextAlign,
    this.subtitleTextAlign,
    this.padding = EdgeInsets.zero,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextAlign? titleTextAlign;
  final TextAlign? subtitleTextAlign;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(
            title,
            textAlign: titleTextAlign,
            style: titleTextStyle,
          ),
          Text(
            subtitle,
            textAlign: subtitleTextAlign,
            style: subtitleTextStyle,
          )
        ],
      ),
    );
  }
}
