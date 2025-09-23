import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/Colors/coluors.dart';

/// Interactive star rating widget
class StarRatingWidget extends StatefulWidget {
  final double initialRating;
  final int maxRating;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;
  final bool allowHalfRating;
  final bool readOnly;
  final ValueChanged<double>? onRatingChanged;
  final MainAxisAlignment mainAxisAlignment;

  const StarRatingWidget({
    super.key,
    this.initialRating = 0.0,
    this.maxRating = 5,
    this.starSize = 20.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.allowHalfRating = false,
    this.readOnly = false,
    this.onRatingChanged,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  void didUpdateWidget(StarRatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _currentRating = widget.initialRating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: List.generate(widget.maxRating, (index) {
        return GestureDetector(
          onTap: widget.readOnly ? null : () => _onStarTapped(index),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            child: Icon(
              _getStarIcon(index),
              size: widget.starSize.w,
              color: _getStarColor(index),
            ),
          ),
        );
      }),
    );
  }

  IconData _getStarIcon(int index) {
    if (_currentRating > index) {
      if (widget.allowHalfRating && _currentRating < index + 1) {
        return Icons.star_half;
      }
      return Icons.star;
    }
    return Icons.star_border;
  }

  Color _getStarColor(int index) {
    if (_currentRating > index) {
      return widget.activeColor;
    }
    return widget.inactiveColor;
  }

  void _onStarTapped(int index) {
    if (widget.readOnly) return;

    double newRating;
    if (widget.allowHalfRating) {
      if (_currentRating == index + 0.5) {
        newRating = index + 1.0;
      } else if (_currentRating == index + 1.0) {
        newRating = index.toDouble();
      } else {
        newRating = index + 0.5;
      }
    } else {
      newRating = index + 1.0;
    }

    setState(() {
      _currentRating = newRating;
    });

    widget.onRatingChanged?.call(newRating);
  }
}

/// Display-only star rating widget
class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;
  final bool allowHalfRating;
  final MainAxisAlignment mainAxisAlignment;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.starSize = 16.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.allowHalfRating = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(maxRating, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          child: Icon(
            _getStarIcon(index),
            size: starSize.w,
            color: _getStarColor(index),
          ),
        );
      }),
    );
  }

  IconData _getStarIcon(int index) {
    if (rating > index) {
      if (allowHalfRating && rating < index + 1) {
        return Icons.star_half;
      }
      return Icons.star;
    }
    return Icons.star_border;
  }

  Color _getStarColor(int index) {
    if (rating > index) {
      return activeColor;
    }
    return inactiveColor;
  }
}

/// Rating summary widget showing average rating and count
class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final double starSize;
  final TextStyle? ratingTextStyle;
  final TextStyle? countTextStyle;

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    this.starSize = 16.0,
    this.ratingTextStyle,
    this.countTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StarRatingDisplay(
          rating: averageRating,
          starSize: starSize,
        ),
        SizedBox(width: 8.w),
        Text(
          averageRating.toStringAsFixed(1),
          style: ratingTextStyle ??
              TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        SizedBox(width: 4.w),
        Text(
          '($totalRatings)',
          style: countTextStyle ??
              TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}
