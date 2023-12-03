import 'package:natural_languaje_processing_mobile/screens/login/helpers/type_form.dart';

abstract class LoginEvent {}

class LogInEvent extends LoginEvent {}

class CreateAccountEvent extends LoginEvent {}

class LoadFormEvent extends LoginEvent {
  FormType type;
  LoadFormEvent(this.type);
}

class ResetEvent extends LoginEvent{}