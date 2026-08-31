import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

class WorkerCard extends StatelessWidget {
  final VoidCallback onTap;
  final CategoryWorkerModel worker;
  const WorkerCard({super.key, required this.onTap, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.11),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: (worker.imageUrl.isNotEmpty && worker.imageUrl.startsWith('http'))
                ? NetworkImage(worker.imageUrl)
                : null,
            child: (worker.imageUrl.isEmpty || !worker.imageUrl.startsWith('http'))
                ? Icon(Icons.person, size: 30, color: Colors.grey)
                : null,
          ),

          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  worker.role,
                  style: TextStyle(color: Color(0xFF6C3CE1), fontSize: 13),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      worker.distance,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // after Expanded Column
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 17),
                  SizedBox(width: 4),
                  Text(
                    worker.rating.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
              OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF6C3CE1)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                child: Text('View', style: TextStyle(color: Color(0xFF6C3CE1))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

