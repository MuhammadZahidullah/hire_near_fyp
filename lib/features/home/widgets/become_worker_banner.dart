import 'package:flutter/material.dart';

class BecomeWorkerBanner extends StatelessWidget {
  final VoidCallback onTap;
  const BecomeWorkerBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      width: double.infinity,
      //  height: 150,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFF6C3CE1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a Worker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Earn money by offering \nyour servicing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    print('JOIN NOW TAPPED');
                    onTap();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF6C3CE1),
                  ),
                  child: Text('Join Now'),
                ),

                //Image.asset(''),
              ],
            ),
          ),
          Icon(Icons.engineering, size: 80, color: Colors.white),
        ],
      ),
    );
  }
}
