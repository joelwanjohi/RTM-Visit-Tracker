import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/statistics/domain/entities/statistics.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, Statistics>> getStatistics();
}