import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

class WorkerCard extends StatelessWidget {
  final VoidCallback onTap;
  final CategoryWorkerModel worker;
  const WorkerCard({super.key, required this.onTap, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: (worker.imageUrl.isNotEmpty && worker.imageUrl.startsWith('http'))
                    ? NetworkImage(worker.imageUrl)
                    : null,
                child: (worker.imageUrl.isEmpty || !worker.imageUrl.startsWith('http'))
                    ? Icon(Icons.person, size: 28, color: Colors.grey.shade400)
                    : null,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            worker.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                            SizedBox(width: 2),
                            Text(
                              worker.rating.toStringAsFixed(1),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      worker.role,
                      style: TextStyle(color: Color(0xFF6C3CE1), fontSize: 13, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  worker.distance,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'View',
                          style: TextStyle(color: Color(0xFF6C3CE1), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

