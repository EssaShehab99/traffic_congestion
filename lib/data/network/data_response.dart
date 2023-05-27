abstract class Result<T> {
}
class Success<T> extends Result<T> {
  final T? value;

  Success([this.value]);
}
class NotValid<T> extends Result<T> {
  NotValid();
}
class Error<T> extends Result<T> {
  final String? message;
  Error([this.message]);
}
