import 'package:flutter/material.dart';
import '../models/perangkat.dart';

class DetailPerangkatSheet extends StatelessWidget {
  final Perangkat perangkat;
  const DetailPerangkatSheet({super.key, required this.perangkat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(perangkat.nama,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text('Fungsi: ${perangkat.fungsi}'),
          Text('Status: ${perangkat.status}'),
          Text('Spesifikasi: ${perangkat.spesifikasi}'),
        ],
      ),
    );
  }
}