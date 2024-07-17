
import '../../model/success_fail_model.dart';

class AirlineAddState {}

class AirlineAddInitial extends AirlineAddState {}

class AirlineAddLoading extends AirlineAddState {}

class AirlineAddSuccess extends AirlineAddState {
  final SuccessFailModel successFailModel;
  AirlineAddSuccess(this.successFailModel);
}

class AirlineAddFailure extends AirlineAddState {
  final String error;
  AirlineAddFailure(this.error);
}