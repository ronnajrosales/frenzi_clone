import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatelessWidget {
  final String text;
  
  const CustomBackButton({
    Key? key,
    this.text = 'Back',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new SvgPicture.asset(
            'assets/images/arrow_back.svg',
            width: 24,
            height: 24,
           
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 