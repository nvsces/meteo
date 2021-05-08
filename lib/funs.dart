String generateData() {
  double temp = 23.3;
  double temp1 = 23.4;
  double temp2 = 22.0;
  double hum = 66;
  double hum1 = 64;
  double pres = 765;

  return "${temp}q${temp1}q${temp2}q${hum}q${hum1}q${pres}q${DateTime.now()}";
}

double serchMin(List<double> data) {
  if (data.isEmpty) return 1;
  double minValue = data[0];
  for (int i = 1; i < data.length; i++) {
    if (data[i] < minValue) {
      minValue = data[i];
    }
  }

  return minValue;
}

List<double> normValue(List<double> graph, double value) {
  for (int j = 0; j < graph.length; j++) {
    graph[j] = graph[j] / value;
  }
  return graph;
}
