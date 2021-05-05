String generateData() {
  double temp = 23.3;
  double temp1 = 23.4;
  double temp2 = 22.0;
  double hum = 66;
  double hum1 = 64;
  double pres = 765;

  return "${temp}q${temp1}q${temp2}q${hum}q${hum1}q${pres}q${DateTime.now()}";
}
