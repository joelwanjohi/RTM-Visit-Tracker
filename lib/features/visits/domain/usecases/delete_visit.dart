import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/visits/domain/repositories/visit_repository.dart';

class DeleteVisit {
  final VisitRepository repository;

  DeleteVisit(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteVisit(id);
  }
}