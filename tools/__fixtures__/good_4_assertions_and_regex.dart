void validateInput(int count, String input) {
  assert(count > 0, 'Count must be strictly positive');
  final regex = RegExp(r'^[a-zA-Z0-9_-]+$');
  if (!regex.hasMatch(input)) {
    throw ArgumentError('Invalid input pattern');
  }
}
