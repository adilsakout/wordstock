import 'package:flutter/material.dart';

class WordStockSlider extends StatefulWidget {
  const WordStockSlider({
    required this.onChanged,
    this.currentValue = 10,
    super.key,
  });

  final void Function(int) onChanged;
  final int currentValue;

  @override
  WordStockSliderState createState() => WordStockSliderState();
}

class WordStockSliderState extends State<WordStockSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xffDDF4FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff84D8FF), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              '${widget.currentValue} words a day',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff1899D6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Slider(
                value: widget.currentValue.toDouble(),
                min: 5,
                max: 30,
                divisions: 5,
                label: '${widget.currentValue}',
                onChanged: (value) {
                  widget.onChanged(value.toInt());
                },
                activeColor: const Color(0xff1899D6),
                inactiveColor: const Color(0xff84D8FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
