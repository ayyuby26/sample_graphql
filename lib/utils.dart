import 'dart:convert';

String jsonPretty(Object jsonObject) {
  return const JsonEncoder.withIndent('  ').convert(jsonObject);
}

Map deleteTypeName(Map data) {
  data.removeWhere((key, val) {
    if (key == "__typename") return true;
    if (val is List) val.map((e) => deleteTypeName(e)).toList();
    if (val is Map) val.removeWhere(mapRemove);
    return false;
  });
  return data;
}

bool mapRemove(key, val) {
  if (key == "__typename") return true;
  if (val is List || val is Map) val.map((e) => deleteTypeName(e)).toList();
  return false;
}