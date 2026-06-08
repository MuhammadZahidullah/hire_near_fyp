import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/worker_model.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/worker_card.dart';

class PopularWorkersSection extends StatelessWidget {
  final List<WorkerModel> workers;
  const PopularWorkersSection({super.key, required this.workers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular workers',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: workers.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return WorkerCard(onTap: () {}, worker: workers[index]);
          },
        ),
      ],
    );
  }
}
