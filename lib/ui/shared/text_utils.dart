upperFirst(String str) {
  if (str.isEmpty) return "";
  if (str.length == 1) return str.toUpperCase();
  return "${str[0].toUpperCase()}${str.substring(1, str.length)}";
}

upperEachFirst(String str) {
  return str.split(" ").map(upperFirst).reduce((curr, next) => "$curr $next");
}

dateToString(DateTime date) {
  var month = date.month >= 10 ? date.month : '0${date.month}';
  var day = date.day >= 10 ? date.day : '0${date.day}';
  return '${date.year}-$month-$day';
}

loremIpsum() {
  return "Al contrario del pensamiento popular, el texto de Lorem Ipsum no es simplemente texto aleatorio. Tiene sus raices en una pieza cl´sica de la literatura del Latin, que data del año 45 antes de Cristo, haciendo que este adquiera mas de 2000 años de antiguedad. Richard McClintock, un profesor de Latin de la Universidad de Hampden-Sydney en Virginia, encontró una de las palabras más oscuras de la lengua del latín, 'consecteur', en un pasaje de Lorem Ipsum, y al seguir leyendo distintos textos del latín, descubrió la fuente indudable. Lorem Ipsum viene de las secciones 1.10.32 y 1.10.33 de 'de Finnibus Bonorum et Malorum' (Los Extremos del Bien y El Mal) por Cicero, escrito en el año 45 antes de Cristo. Este libro es un tratado de teoría de éticas, muy popular durante el Renacimiento. La primera linea del Lorem Ipsum, 'Lorem ipsum dolor sit amet..', viene de una linea en la sección 1.10.32";
}
