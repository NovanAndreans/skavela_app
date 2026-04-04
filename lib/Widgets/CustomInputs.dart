import 'package:flutter/material.dart';

Widget CustomInputText(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }