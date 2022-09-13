import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class AuthenticationRepository{
  Future<Either<Failure,List<String>>> getMnemonic();
}