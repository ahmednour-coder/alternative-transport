String _two(int value) => value.toString().padLeft(2, '0');

String formatDate(DateTime date) =>
    '${_two(date.day)}/${_two(date.month)}/${date.year}';

String formatTime(DateTime date) => '${_two(date.hour)}:${_two(date.minute)}';

String formatDateTime(DateTime date) =>
    '${formatDate(date)} · ${formatTime(date)}';

String formatMoney(double value) => '${value.toStringAsFixed(2)} TND';

String formatPrice(double value) {
  final isRound = value == value.roundToDouble();
  return isRound ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
}

String formatDurationLabel(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours == 0) return '$minutes min';
  if (minutes == 0) return '$hours h';
  return '$hours h ${_two(minutes)}';
}

String formatCountdown(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  return '${_two(safe.inMinutes)}:${_two(safe.inSeconds.remainder(60))}';
}

String formatKm(double km) => '${km.toStringAsFixed(1)} km';

String initialsOf(String firstName, String lastName) {
  final first = firstName.trim();
  final last = lastName.trim();
  final a = first.isEmpty ? '' : first[0];
  final b = last.isEmpty ? '' : last[0];
  final result = '$a$b'.toUpperCase();
  return result.isEmpty ? 'AT' : result;
}
