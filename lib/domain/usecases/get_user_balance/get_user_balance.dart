import 'package:flix_movie/data/repositories/user/user_repository.dart';
import 'package:flix_movie/domain/entities/result/result.dart';
import 'package:flix_movie/domain/usecases/get_user_balance/get_user_balance_param.dart';
import 'package:flix_movie/domain/usecases/usecase.dart';

class GetUserBalance implements UseCase<Result<int>, GetUserBalanceParam> {
  final UserRepository _userRepository;

  GetUserBalance({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Result<int>> call(GetUserBalanceParam params) =>
      _userRepository.getUserBalance(uid: params.userId);
}
