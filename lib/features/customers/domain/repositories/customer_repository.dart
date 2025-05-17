import 'package:dartz/dartz.dart';
import 'package:rtm_visit_tracker/core/error/failures.dart';
import 'package:rtm_visit_tracker/features/customers/domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<Customer>>> getAllCustomers();
}