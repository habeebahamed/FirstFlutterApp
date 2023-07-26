import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class Meal {
  final String name;
  final ValueNotifier<int> value;

  Meal(this.name, int value) : this.value = ValueNotifier<int>(value);
}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

//first page
class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


//second page
class MyChartPage extends StatelessWidget {

  final List<Meal> mealsData;
  final DateTime selectedDate;


  // Sample data
  final List<String> meals = ['Breakfast', 'Lunch', 'Dinner']; // Meals

  MyChartPage(this.mealsData, this.selectedDate);

  //final List<double> data = [4000, 3500, 2500]; // Calories


  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFFBD9382);
    return Scaffold(
      backgroundColor: myColor,
      body: Stack(
        children: [
          // Profile icon in the top-left corner
          Positioned(
            top: 60, // top position
            left: 20, // left position
            child: GestureDetector(
              onTap: () {
                // Add functionality to navigate to the profile screen or any other action you want.
                // Example:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.person, // Icon
                    size: 40,
                    color: Colors.blueAccent,// Adjust icon size
                  ),
                  SizedBox(width: 10), // spacing between icon and text
                  Text(
                    'Jay', // profile name
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.bold), // text size
                  ),
                ],
              ),
            ),
          ),
          // Profile Heading
          const Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Align(
                alignment: Alignment.center,
                child: Text(
                    'Daily Summary',
                    style: TextStyle(fontFamily: 'Rubik Dirt',fontSize: 30)
                )
            ),
          ),
          Positioned(
            top: 180,
            left: 80,
            right: 0,
            child: Text(
              DateFormat('dd/MM/yyyy').format(selectedDate),
              style: const TextStyle(fontFamily: 'Oswald', fontSize: 30, color: Colors.blue),
            )

          ),
          //App Content
          Center(
            child: AspectRatio(
              aspectRatio: 1.3, // modify the chart size
              child: PieChart(
                PieChartData(
                  sections: getSections(),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0, // Adjust the center space
                  //centerSpaceColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    List<Color> colors = [Colors.purple, Colors.purpleAccent, Colors.deepPurple]; // Colors for each data point

    // double totalCalories = data.reduce((value, element) => value + element); // Calculate the total sum
    int totalCalories = mealsData.map((meal) => meal.value.value).reduce((value, element) => value + element); // Calculate the total sum

    return List.generate(3, (index) {
      double percentage = (mealsData[index].value.value / totalCalories) * 100; // Calculate the percentage

      return PieChartSectionData(
        color: colors[index],
        value: mealsData[index].value.value.toDouble(),
        title: '${meals[index]}\n${percentage.toStringAsFixed(1)}%', // Display data point percentage as title
        radius: 130,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      );
    });
  }
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    //listener to each meal's value notifier to trigger UI updates
    meals.forEach((meal) {
      meal.value.addListener(_onMealValueChanged);
    });
  }

  @override
  void dispose() {
    // Remove the listeners when the widget is disposed of to avoid memory leaks
    meals.forEach((meal) {
      meal.value.removeListener(_onMealValueChanged);
    });
    super.dispose();
  }

  void _onMealValueChanged() {
    // Notify the framework that the state has changed, triggering a rebuild
    setState(() {});
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFFBD9382);
    return Scaffold(
      backgroundColor: myColor,
      body: Stack(
        children: [
          // App content goes here
          Center(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildMealTable(),
          ),
          ),
          // Profile icon in the top-left corner
          Positioned(
            top: 60, // top position
            left: 20, // left position
            child: GestureDetector(
              onTap: () {
                // Add functionality to navigate to the profile screen or any other action you want.
                // Example:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.person, // Icon
                    size: 40,
                    color: Colors.blueAccent,// Adjust icon size
                  ),
                  SizedBox(width: 10), // spacing between icon and text
                  Text(
                    'Jay', // profile name
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.bold), // text size
                  ),
                ],
              ),
            ),
          ),
          // Profile Heading
          const Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Align(
                alignment: Alignment.center,
                child: Text(
                    'Daily caloric intake',
                    style: TextStyle(fontFamily: 'Rubik Dirt',fontSize: 30)
                )
            ),
          ),
          Positioned(
            top: 170, // Adjust the top position as needed
            left: 45, // Adjust the left position as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_selectedDate != null)
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                        width: 2, color: Colors.blue
                    ),
                  ),
                  child:  Text(
                    _selectedDate == null ? 'Date' : 'Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'.split(' ')[2],
                    style: const TextStyle(color: Colors.blue, fontFamily: 'Oswald'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 10,
            right: 10,
            child: ElevatedButton(
                  onPressed: () {
                    int index;
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return MyChartPage(meals, _selectedDate!);
                    }));

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                        width: 2, color: Colors.blue
                    ),
                  ),
              child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                      'View Graph',
                      style: TextStyle(fontSize: 20, color: Colors.blue, fontFamily: 'Oswald')
                  )
              ),
                ),
          ),
        ],
      ),
    );
  }
}



final List<Meal> meals = [
  Meal('Breakfast', 4000),
  Meal('Lunch', 3500),
  Meal('Dinner', 2500),
];

Widget buildMealTable() {

  //add the body font
  TextStyle customTextStyle = const TextStyle(
    fontFamily: 'Oswald', // Use the custom font family name here
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  const Color customColor = Color(0xFF16EA82);
  const Color backgroundCellColor = Color(0xFFFA7204);
  return Table(
    border: TableBorder.all(width: 1.0, color: Colors.transparent,
    ),
    children: [
      const TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Center(child: Text('')),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Center(child: Text('')),
            ),
          ),
        ],
      ),
      for (var i = 0; i < meals.length; i++)
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Center(child: Text(meals[i].name, style: const TextStyle(fontSize: 30, color: Colors.black, fontFamily: 'Oswald'), )),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                    child: TextField(
                      controller: TextEditingController(
                          text: meals[i].value.value.toString()),
                          style: const TextStyle(
                              fontSize: 30, color: customColor, fontFamily: 'Oswald'
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value){
                            meals[i].value.value = int.parse(value); //updating the value
                          },
                    )
                ),
              ),
            ),
          ],
        ),
      const TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Center(child: Text('')),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Center(child: Text('')),
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          TableCell(
            child: Container(
              color: backgroundCellColor, // Set the background color of the cell
              padding: const EdgeInsets.all(8.0),
              child: const Center(child: Text(
                  'Total', style: TextStyle(
                  fontSize: 30,
                  color: Colors.purple,
                  fontFamily: 'Oswald'
                  )
                )
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                  child: Text(
                      calculateTotal().toString(),
                      style: const TextStyle(
                        fontSize: 30, color: Colors.purple, fontFamily: 'Oswald'
                      )
                  )
              ),
            )
          ),
        ],
      ),

    ],
  );
}

int calculateTotal() {
  //return meals.map((meal) => meal.value).reduce((sum, value) => sum + value); //breakfast+lunch+dinner
  return meals.map((meal) => meal.value.value).reduce((sum, value) => sum + value);
}