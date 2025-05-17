import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/visits/domain/entities/visit.dart';

abstract class VisitRepository {
  Future<Either<Failure, List<Visit>>> getAllVisits();
  Future<Either<Failure, Visit>> addVisit(Visit visit);
  Future<Either<Failure, Visit>> updateVisit(Visit visit);
  Future<Either<Failure, Unit>> deleteVisit(int id);
}