import 'package:flutter/material.dart';

class QuantityPicker extends StatelessWidget {
  final double quantity;
  final ValueChanged<double> onChanged;

  const QuantityPicker({super.key, required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (quantity > 0.1) {
              onChanged(quantity - 0.1);
            }
          },
          icon: const Icon(Icons.remove),
        ),
        Text(quantity.toStringAsFixed(1),
         
        ), 
        IconButton(
          onPressed: () {
            onChanged(quantity + 0.1);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
