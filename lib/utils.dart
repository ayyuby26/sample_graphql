import 'dart:convert';

String jsonPretty(Object jsonObject) {
  return const JsonEncoder.withIndent('  ').convert(jsonObject);
}