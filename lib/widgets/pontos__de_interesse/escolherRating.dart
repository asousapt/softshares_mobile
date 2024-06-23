import 'package:flutter/material.dart';

class RatingPicker extends StatefulWidget {
  final int initialRating;
  final Function(int) onRatingSelected;

  RatingPicker({required this.initialRating, required this.onRatingSelected});

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<RatingPicker> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Flexible(
          child: IconButton(
            padding: EdgeInsets.all(0),
            constraints: const BoxConstraints(),
            iconSize: 25,
            icon: Icon(
              index < _currentRating ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            onPressed: () {
              setState(() {
                _currentRating = index + 1;
              });
              widget.onRatingSelected(_currentRating);
            },
          ),
        );
      }),
    );
  }
}