import 'package:flutter/material.dart';

/// Stateless widget in charge of ONLY the visual representation of the
/// button (blue oval when selected, white/outlined oval when not).
/// All state lives in the parent screen (ButtonScreen).
class ButtonWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const ButtonWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade400,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
