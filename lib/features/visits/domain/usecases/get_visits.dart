import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/visits/domain/entities/visit.dart';
import 'package:rtm_visit_tracker/features/visits/domain/repositories/visit_repository.dart';

class GetVisits {
  final VisitRepository repository;

  GetVisits(this.repository);

  Future<Either<Failure, List<Visit>>> call() async {
    return await repository.getAllVisits();
  }
}