import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/activities/domain/entities/activity.dart';
import 'package:rtm_visit_tracker/features/activities/domain/repositories/activity_repository.dart';

class GetActivities {
  final ActivityRepository repository;

  GetActivities(this.repository);

  Future<Either<Failure, List<Activity>>> call() async {
    return await repository.getAllActivities();
  }
}