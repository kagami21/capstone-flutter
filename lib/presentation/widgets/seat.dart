import 'package:flix_movie/presentation/misc/constants.dart';
import 'package:flutter/material.dart';

enum SeatStatus { available, reserved, selected }

class Seat extends StatelessWidget {
  final int? number;
  final SeatStatus status;
  final double size;
  final VoidCallback? onTap;

  const Seat(
      {Key? key,
      this.number,
      this.status = SeatStatus.available,
      this.size = 30,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool available = status == SeatStatus.available;
    bool reserved = status == SeatStatus.reserved;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: available
              ? Colors.white
              : reserved
                  ? Colors.grey
                  : saffron,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            '${number ?? ''}',
            style: const TextStyle(
                color: backgroundColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
