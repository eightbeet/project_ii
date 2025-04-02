import 'package:flutter/material.dart';

class GoalsWidget extends StatefulWidget {
  @override
  _GoalsWidgetState createState() => _GoalsWidgetState();
}

class _GoalsWidgetState extends State<GoalsWidget> {
  // [DUMMYDATA:]
  Map<String, Map<String, dynamic>> goals = {
    'Daily': {'timeGoal': 2, 'isActive': true},
    'Weekly': {'timeGoal': 10, 'isActive': true},
    'Monthly': {'timeGoal': 40, 'isActive': false},
  };

  // [DUMMYDATA:]
  Map<String, List<Color>> goalGradients = {
    'Daily':  [Color(0xFF919191), Color(0xFF9BA7CF), Color(0xFF004B3B)],
    'Weekly': [Color(0xFF004B3B), Color(0xFFCCCED9), Color(0xFF000000)],
    'Monthly':[Color(0xFFB00020), Color(0xFFFCD9DF), Color(0xFFA4A7BC)],
  };

  void _toggleGoal(String goalType) {
    setState(() {
      goals[goalType]?['isActive'] = !(goals[goalType]?['isActive'] ?? false);
    });
  }

  void _deleteGoal(String goalType) {
    setState(() {
      goals.remove(goalType);
    });
   }
  void _addGoal() {
    String newGoalName = '';
    int newTimeGoal = 0;
    bool isActive = true;

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
                  newGoalName = nameController.text;
                  newTimeGoal = int.tryParse(timeController.text) ?? 0;
                  if (newGoalName.isNotEmpty && newTimeGoal > 0) {
                    goals[newGoalName] = {'timeGoal': newTimeGoal, 'isActive': isActive};
                  }
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

  void _editGoalTime(String goalType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: goals[goalType]?['timeGoal'].toString());

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
                  goals[goalType]?['timeGoal'] = int.tryParse(controller.text) ?? goals[goalType]?['timeGoal'];
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
            children: goals.keys.map((goalType) {
              final gradient = goalGradients[goalType] ?? [Colors.grey, Colors.grey];

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
                            goalType,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Delete') {
                                _deleteGoal(goalType);
                              } else if (value == 'Edit Time') {
                                _editGoalTime(goalType);
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
                        '${goals[goalType]?['timeGoal']} h',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100),
                      ),
                      SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Switch(
                            value: goals[goalType]?['isActive'] ?? false,
                            onChanged: (_) => _toggleGoal(goalType),
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
  }
}
