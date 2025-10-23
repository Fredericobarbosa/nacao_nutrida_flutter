import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final TextInputType keyboardType;
  final bool enabled;
  final bool compact;

  const ProfileField({
    Key? key,
    required this.label,
    required this.value,
    this.keyboardType = TextInputType.text,
    this.enabled = false,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        SizedBox(height: compact ? 2 : 4),
        TextFormField(
          initialValue: value,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: compact ? 6 : 12,
            ),
          ),
        ),
      ],
    );
  }
}
