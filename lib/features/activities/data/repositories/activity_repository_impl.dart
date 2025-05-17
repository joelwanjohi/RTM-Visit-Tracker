import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/activities/data/datasources/activity_local_data_source.dart';
import 'package:rtm_visit_tracker/features/activities/data/datasources/activity_remote_data_source.dart';
import 'package:rtm_visit_tracker/features/activities/data/models/activity_model.dart';
import 'package:rtm_visit_tracker/features/activities/domain/entities/activity.dart';
import 'package:rtm_visit_tracker/features/activities/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;
  final ActivityLocalDataSource localDataSource;
  final Connectivity connectivity;

  ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Activity>>> getAllActivities() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        final localActivities = await localDataSource.getActivities();
        return Right(localActivities.map((model) => model.toEntity()).toList());
      }
      final remoteActivities = await remoteDataSource.getActivities();
      await localDataSource.cacheActivities(remoteActivities);
      return Right(remoteActivities.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to fetch activities: $e'));
    }
  }
}