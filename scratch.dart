void main() {
  var d1 = DateTime.tryParse("2026-05-20");
  print("d1: ${d1?.toUtc().toIso8601String()}");
  var d2 = DateTime(2026, 5, 20);
  print("d2: ${d2.toUtc().toIso8601String()}");
  var d3 = DateTime.parse("2026-05-21T00:00:00Z");
  print("d3: ${d3.toIso8601String()}");
}
