enum RequestStatus { initial, loading, error, success }

extension RequestStatusExt on RequestStatus? {
  bool get isLoading => this == RequestStatus.loading;

  bool get isError => this == RequestStatus.error;

  bool get isSuccess => this == RequestStatus.success;
}

enum AuthMode { login, signup, otpVerification, forget, verify, change }
