import 'package:flutter/material.dart';

class WorkerBanner extends StatelessWidget {
  final VoidCallback onTap;
  const WorkerBanner({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, child: Icon(Icons.badge)),
          Expanded(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text('Earn with your skills ', style: TextStyle(
                    fontWeight: FontWeight.bold,  // ← bold title
                    fontSize: 14,
                  ),),
                SizedBox(height: 5),
                Text(
                  'Become a worker and start \n earning by offering your services.',
            
                   style: TextStyle(
                    color: Colors.grey,           // ← grey subtitle
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
               backgroundColor: Color(0xFF5B3FE4),  // purple
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
            ),
            child: Text('Become a worker', style: TextStyle(color: Colors.white, fontSize: 12),),),
        ],
      ),
    );
  }
}
