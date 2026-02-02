import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? buttonText;
  final Color? backgroundColor;
  final String? buttonIcon;
  final double? iconSize;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    this.buttonText,
    this.onPressed,
    this.backgroundColor,
    this.buttonIcon,
    this.iconSize,
  });

  @override
  State<CustomButton> createState() => _CustomButton();
}

class _CustomButton extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48),
        backgroundColor: widget.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          ?widget.buttonIcon != null
              ? Image.asset(
                  widget.buttonIcon ?? "",
                  width: widget.iconSize ?? 50,
                )
              : null,
          Text(
            widget.buttonText ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
