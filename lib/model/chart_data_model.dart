class ChartData {
  ChartData(
    this.x,
    this.y,
  );
  final DateTime x;
  final int y;
}

class GlucoseData {
  GlucoseData(this.time, this.glucose);
  final DateTime time;
  final double glucose;
}

class ChartSampleData {
  ChartSampleData(this.time, this.glucose);
  final DateTime time;
  final double glucose;
}


