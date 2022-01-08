upperFirst(String str) {
  if (str.isEmpty) return "";
  if (str.length == 1) return str.toUpperCase();
  return "${str[0].toUpperCase()}${str.substring(1, str.length)}";
}

upperEachFirst(String str) {
  return str.split(" ").map(upperFirst).reduce((curr, next) => "$curr $next");
}
