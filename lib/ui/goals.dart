import 'package:flutter/material.dart';

import '../data/goals.dart';

class GoalsWidget extends StatefulWidget {
  @override
  _GoalsWidgetState createState() => _GoalsWidgetState();
}

class _GoalsWidgetState extends State<GoalsWidget> {
  // [DUMMYDATA:]
  List<GoalData> goals = [
    // 'Daily': {'timeGoal': 2, 'isActive': true},
    // 'Weekly': {'timeGoal': 10, 'isActive': true},
    // 'Monthly': {'timeGoal': 40, 'isActive': false},
  ];
  

  Future<List<GoalData>> getGoalData() async {
   List<GoalData> _goals = [];
    final data = await AppGoalsHelper().getAllGoals();
    for(var item in data) {
       final goal = AppGoalsHelper().goalFormat(item);
      _goals.add(goal);
    }
    return _goals;
  }

  void _toggleGoal(GoalData goal) {
    setState(() {
         goal.isActive = !goal.isActive;
         AppGoalsHelper().updateGoal(goal);
    });
  }

  void _deleteGoal(int? id ) {
    setState(() {
      // goals.remove(goal);
      AppGoalsHelper().deleteGoal(id);
    });
   }
  void _addGoal() {
    String newGoalKind = '';
    int newTimeGoal = 0;
    bool isActive = true;
    bool isAchieved = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController timeController = TextEditingController();

        return AlertDialog(
          title: Text("Add New Goal"),
          backgroundColor: Theme.of(context).colorScheme.surfaceDim,
          shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Goal Name (e.g., Daily, Weekly)'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Time Goal (hours)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                        ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
             style: TextButton.styleFrom(
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), 
                        ),
              ),
              onPressed: () {
                setState(() {
                  newGoalKind = nameController.text;
                  newTimeGoal = int.tryParse(timeController.text) ?? 0;
                  if (newGoalKind.isNotEmpty && newTimeGoal > 0) {
                    final goal = GoalData(duration : newTimeGoal, isAchieved: isAchieved, isActive: isActive, kind: newGoalKind);
                    AppGoalsHelper().insertGoal(goal);
                    // goals.add(goal);
                    };
                });
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ), 
          ],
        );
      },
    );
  }

  void _editGoalTime(GoalData goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: goal.duration.toString());

        return AlertDialog(
          title: Text("Edit Time Goal"),
          backgroundColor: Theme.of(context).colorScheme.surfaceDim,
          shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30),
          ),
          content: TextField( controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'New time goal (hours)'),
          ),
          actions: [
            TextButton(
               style: TextButton.styleFrom(
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                        ),
               ),
              onPressed: () {
                setState(() {
                  goal.duration = int.tryParse(controller.text) ?? goal.duration;
                  AppGoalsHelper().updateGoal(goal);
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
            TextButton(
               style: TextButton.styleFrom(
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                        ),
               ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

  Map<String, List<Color>> goalGradients = {
    'Daily':  [Theme.of(context).colorScheme.outline, Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.tertiary],
    'Weekly': [Theme.of(context).colorScheme.tertiary, Theme.of(context).colorScheme.tertiaryFixed, Theme.of(context).colorScheme.onSurface],
    'Monthly':[Theme.of(context).colorScheme.error, Theme.of(context).colorScheme.errorContainer, Theme.of(context).colorScheme.primaryFixedDim],
  };

   return FutureBuilder<List<GoalData>>(
      future: getGoalData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
           print("[NO_DATA]: Snapshot is empty, data not avilable!");
          // return Center(child: Text('No data available'));
        }

      goals = snapshot.data!;

      return Column(

        children: [
         Container(
          padding: EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Goals',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 10),
            ],
            ),
          ),

        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () =>  _addGoal(),
              child: Icon(Icons.add, size: 24, color: Theme.of(context).colorScheme.primary),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(width: 40),
          ],
        ),

        SizedBox(height: 10),
        Expanded(
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: goals.map((goal) {
              final gradient = goalGradients[goal.kind] ?? [Colors.grey, Colors.grey];

              return Container(
                width: 150, 
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goal.kind,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Delete') {
                                _deleteGoal(goal.id);
                              } else if (value == 'Edit Time') {
                                _editGoalTime(goal);
                              }
                            },
                            shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                            ),
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'Edit Time',
                                  child: Text('Edit Time'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ];
                            },
                            icon: Icon(Icons.more_vert, size: 24),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),

                      Text(
                        '${goal.duration} h',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100),
                      ),
                      SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Switch(
                            value: goal.isActive,
                            onChanged: (_) => _toggleGoal(goal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
    });
  }
}
