enum RequestStatus {
  pending,
  accepted,
  rejected;

  static RequestStatus stringToRequestStatus(String name) {
    try {
      return RequestStatus.values.firstWhere(
        (status) => status.name == name,
      );
    } on Exception catch (_) {
      return RequestStatus.pending;
    }
  }
}
