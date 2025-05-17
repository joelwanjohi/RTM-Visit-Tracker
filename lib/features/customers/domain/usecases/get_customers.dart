import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/customers/domain/entities/customer.dart';
import 'package:rtm_visit_tracker/features/customers/domain/repositories/customer_repository.dart';

class GetCustomers {
  final CustomerRepository repository;

  GetCustomers(this.repository);

  Future<Either<Failure, List<Customer>>> call() async {
    return await repository.getAllCustomers();
  }
}