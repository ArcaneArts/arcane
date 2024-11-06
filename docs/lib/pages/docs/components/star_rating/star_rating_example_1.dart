import 'package:arcane/arcane.dart';

class StarRatingExample1 extends StatefulWidget {
  const StarRatingExample1({super.key});

  @override
  State<StarRatingExample1> createState() => _StarRatingExample1State();
}

class _StarRatingExample1State extends State<StarRatingExample1> {
  double value = 1.5;
  @override
  Widget build(BuildContext context) {
    return StarRating(
      starSize: 32,
      value: value,
      onChanged: (value) {
        setState(() {
          this.value = value;
        });
      },
    );
  }
}
