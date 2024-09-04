import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrainingJournalScreen(),
    );
  }
}

class TrainingJournalScreen extends StatefulWidget {
  @override
  _TrainingJournalScreenState createState() => _TrainingJournalScreenState();
}

class _TrainingJournalScreenState extends State<TrainingJournalScreen> {
  String selectedDate = DateTime.now().toIso8601String().split('T')[0];
  Map<String, Map<String, double>>? trainingData;
  double currentWeight = 0.0;
  double currentCalories = 0.0;
  String currentDuration = '0 min';

  @override
  void initState() {
    super.initState();
    List<String> dates = [
      "2024-05-13",
      "2024-05-14",
      "2024-05-15",
    ];
    loadTrainingData(dates);
  }

  Future<Map<String, Map<String, double>>> getTrainingData(
      String userId, List<String> dates) async {
    try {
      Map<String, Map<String, double>> allData = {};

      for (String date in dates) {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(userId)
            .collection('seancesEntrainement')
            .doc(date)
            .get();

        if (snapshot.exists) {
          allData[date] = {
            'poids': snapshot.data()?['poids']?.toDouble() ?? 0.0,
            'calories': snapshot.data()?['calories']?.toDouble() ?? 0.0,
            'dureeEntrainement': snapshot.data()?['dureeEntrainement']?.toDouble() ?? 0.0,
          };
        } else {
          allData[date] = {'poids': 0.0, 'calories': 0.0, 'dureeEntrainement': 0.0};
        }
      }

      return allData;
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

  void loadTrainingData(List<String> dates) async {
    var data = await getTrainingData("JFMn4NLcgElxrvmp6S6n", dates);
    print("Loaded training data: $data");
    setState(() {
      trainingData = data;
      if (data.containsKey(selectedDate)) {
        currentWeight = data[selectedDate]!['poids'] ?? 0.0;
        currentCalories = data[selectedDate]!['calories'] ?? 0.0;
        currentDuration = '${data[selectedDate]!['dureeEntrainement'] ?? 0.0} min';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal d\'entraînement'),
        centerTitle: true,
      ),
      body: trainingData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarSection(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                  if (trainingData != null) {
                    currentWeight = trainingData![selectedDate]!['poids'] ?? 0.0;
                    currentCalories = trainingData![selectedDate]!['calories'] ?? 0.0;
                    currentDuration = '${trainingData![selectedDate]!['dureeEntrainement'] ?? 0.0} min';
                  }
                });
              },
            ),
            StatsSection(
              duration: currentDuration,
              calories: currentCalories.toString(),
            ),
            WeightStatisticsSection(
              allData: trainingData ?? {},
            ),
            TrainingHistorySection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bike), label: 'Entraînement'),
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Progression'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Progression'),
        ],
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey,
      ),
    );
  }
}

class CalendarSection extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateSelected;

  CalendarSection({required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        itemBuilder: (context, index) {
          String date = "2024-05-${13 + index}"; // Example date generation
          return GestureDetector(
            onTap: () {
              onDateSelected(date);
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayOfWeek(index),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text('${13 + index}'),
                  SizedBox(height: 8.0),
                  Icon(
                    Icons.circle,
                    size: 8.0,
                    color: date == selectedDate ? Colors.yellow : Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayOfWeek(int index) {
    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[index % 7];
  }
}

class StatsSection extends StatelessWidget {
  final String duration;
  final String calories;

  StatsSection({required this.duration, required this.calories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatCard(
              title: 'Entraînement',
              value: duration,
              icon: Icons.fitness_center),
          StatCard(
              title: 'Calories',
              value: '$calories Kcal',
              icon: Icons.local_fire_department),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 86.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.yellow, size: 20.0),
              SizedBox(width: 6.0),
              Text(title, style: TextStyle(fontSize: 14.0)),
            ],
          ),
          SizedBox(height: 6.0),
          Text(value,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class WeightStatisticsSection extends StatelessWidget {
  final Map<String, Map<String, double>> allData;

  WeightStatisticsSection({required this.allData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> weightSpots = [];
    List<FlSpot> caloriesSpots = [];
    List<FlSpot> durationSpots = [];

    allData.forEach((date, data) {
      double x = double.parse(date.split('-')[2]); // Utilisez le jour du mois pour l'axe X

      weightSpots.add(FlSpot(x, data['poids'] ?? 0));
      caloriesSpots.add(FlSpot(x, data['calories'] ?? 0));
      durationSpots.add(FlSpot(x, data['dureeEntrainement'] ?? 0));
    });

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statistiques de poids', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.0),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(spots: weightSpots, isCurved: true, color: Colors.yellow),
                  LineChartBarData(spots: caloriesSpots, isCurved: true, color: Colors.red),
                  LineChartBarData(spots: durationSpots, isCurved: true, color: Colors.blue),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), style: TextStyle(fontSize: 12.0));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), style: TextStyle(fontSize: 12.0));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrainingHistorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historique d\'entraînement',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.0),
          Image.asset(
            'assets/history.jpg',
            width: 326.0,
            height: 139.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
