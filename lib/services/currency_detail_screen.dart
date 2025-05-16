import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'currency_service.dart';
import 'package:flutter/material.dart';


class CurrencyChartScreen extends StatefulWidget {
  final String currencyCode;
  final String currencyName;

  const CurrencyChartScreen({
    super.key,
    required this.currencyCode,
    required this.currencyName,
  });

  @override
  State<CurrencyChartScreen> createState() => _CurrencyChartScreenState();
}

class _CurrencyChartScreenState extends State<CurrencyChartScreen> {
  late Future<Map<DateTime, double>> _futureRates;

  @override
  void initState() {
    super.initState();
    _futureRates = CurrencyService.fetchHistory(widget.currencyCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.currencyCode} Grafiği'),
        backgroundColor: const Color.fromRGBO(255, 193, 7, 1),
      ),
      body: FutureBuilder<Map<DateTime, double>>(
        future: _futureRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Veri bulunamadı"));
          }

          final rates = snapshot.data!;
          final sortedDates = rates.keys.toList()..sort();

          final spots = List.generate(sortedDates.length, (i) {
            return FlSpot(i.toDouble(), rates[sortedDates[i]]!);
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
