import 'package:flutter/material.dart';

Widget customNotifikasiSkeleton() {
  return const Card(
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    elevation: 3,
    child: ListTile(
      title: Text(
        'title',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('message'),
          SizedBox(height: 4),
          Text(
            '1 jam yang lalu',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}
