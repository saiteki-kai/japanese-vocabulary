import 'package:flutter/material.dart';

/// A widget that display in a vertical array a title and a subtitle as text components.
///
/// used for example in the [WordDetailsTab] to show the [Word] meaning, reading and the pos:
/// TitleSubtitleWidget(
///    title: "Reading",
///    titleTextStyle: TextStyle(
///        color: Colors.deepOrange[600],
///        fontWeight: FontWeight.w300),
///    subtitle: word.reading,
///    padding: const EdgeInsets.symmetric(vertical: 8.0),
///    crossAxisAlignment: CrossAxisAlignment.start,
///  )
/// or in the [WordStatsTab] to show the next review date:
/// TitleSubtitleWidget(
///   title: "Next Review",
///   titleTextStyle: const TextStyle(fontWeight: FontWeight.w500),
///   subtitle: DatesUtils.format(word.nextReview),
///   padding: const EdgeInsets.all(8.0),
///  )
class TitleSubtitleWidget extends StatelessWidget {
  /// Creates a title and subtitle widget.
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ///
  /// The [title] and [subtitle] parameters are required and must not be null.
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

  /// The text to display for the title field, must not be null.
  final String title;

  /// The text to display for the subtitle field, must not be null.
  final String subtitle;

  /// If non-null, the style to use for the title field text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? titleTextStyle;

  /// If non-null, the style to use for the subtitle field text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? subtitleTextStyle;

  /// How the text for the title field should be aligned horizontally.
  final TextAlign? titleTextAlign;

  /// How the text for the subtitle field should be aligned horizontally.
  final TextAlign? subtitleTextAlign;

  /// The padding applied around this widget.
  ///
  /// The default padding is [EdgeInsets.zero].
  final EdgeInsetsGeometry padding;

  /// How this widget cross axis will be aligned.
  ///
  /// The default alignment is [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// How this widget main axis will be aligned.
  ///
  /// The default alignment is [MainAxisAlignment.center].
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis for this widget.
  ///
  /// The default is [MainAxisSize.min].
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
