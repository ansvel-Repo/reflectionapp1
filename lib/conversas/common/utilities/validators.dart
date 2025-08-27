mixin Validators {
  String? isEmpty(String? value, String message) {
    if (value != null && value.isEmpty) return message;
    return null;
  }

  String? isEmail(String? value, String message) {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (value != null && !RegExp(pattern).hasMatch(value)) return message;
    return null;
  }

  String? hasSevenChars(String? value, String message) {
    if (value != null && value.length < 7) return message;
    return null;
  }

  String? combineValidators(List<Validator<String?>> validators) {
    for (var func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }
}

typedef Validator<T> = T? Function();
