import 'package:hire_near_fyp/features/home/popular_workers/models/worker_model.dart';

class WorkerData {
  static List<WorkerModel> workerList = [
    WorkerModel(
      distance: '5kM',
      id: 1,
      name: 'Naveed',
      ratting: 4.5,
      role: 'Carpenter',
    ),
    WorkerModel(
      distance: '3KM',
      id: 2,
      name: 'Sajid',
      ratting: 4.8,
      role: 'IT Technician',
    ),
    WorkerModel(
      distance: '6KM',
      id: 3,
      name: 'Shaikh Zia',
      ratting: 4.9,
      role: 'Electrician',
    ),
  ];
}
