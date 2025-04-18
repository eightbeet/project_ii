import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/svc_appblock.dart';

import 'shimmer.dart';

class BlockWidget extends StatefulWidget {
  @override
  _BlockWidgetState createState() => _BlockWidgetState();
}

class _BlockWidgetState extends State<BlockWidget> {
  List<Application> _mediaApps = [];
  List<String> _selectedApps = []; 
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMediaApps();
  }

  Future<void> _getMediaApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true, 
    );
    List<Application> mediaApps = [];
    for (var app in apps) {
         if (
               // app.category == ApplicationCategory.audio   ||
               app.category == ApplicationCategory.video ||
               app.category == ApplicationCategory.image ||
               // app.category == ApplicationCategory.game  ||
               app.category == ApplicationCategory.news  ||
               app.category == ApplicationCategory.social
             ) {
               mediaApps.add(app); 
         }
    }

    setState(() {
      _mediaApps = mediaApps;
    });
  }

  Future<void> _saveLockedApps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blockedApps', _selectedApps);
  }

 void _handleAppSelection(String packageName) {
    setState(() {
      if (_selectedApps.contains(packageName)) {
        _selectedApps.remove(packageName);
      } else {
        _selectedApps.add(packageName);
      }
    });
  }

  // [TODO]: Remember to check if any elements have been selected inorder to trigger AlertDialog.
  void _startBlocking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceDim,
          title: Text('Stage For Blocking'),
          content: Text('Staging apps: ${_selectedApps.join(', ')}'),
          shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30),
          ),
          actions: [
            TextButton(
               style: TextButton.styleFrom(
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), 
                        ),
               ),
               onPressed: () {
                  AppMethodChannelController().stopBackgroundMonitoring();
                  Navigator.pop(context);
               },
               child: Text('Cancel'),
            ),
            TextButton(
               style: TextButton.styleFrom(
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), 
                        ),
               ),
               onPressed: () {
                  _saveLockedApps();
                  AppMethodChannelController().startBackgroundMonitoring();
                  Navigator.pop(context);
               },
               child: Text('Ok'),
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
                  'App Block',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    // Block Button
                    ElevatedButton(
                      onPressed: _startBlocking,
                      child: Icon(Icons.lock, size: 24),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30),
                      ),
                     ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                ],
        ),),
      Expanded(  child: Container(
      child: _mediaApps.isEmpty
          ? BlockShimmer()
          : ListView.separated(
              itemCount: _mediaApps.length,
               // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final app  = _mediaApps[index] as ApplicationWithIcon;
                return CheckboxListTile(
                  title: Text(app.appName),
                  subtitle: Text(app.packageName),
                  value: _selectedApps.contains(app.packageName),
                  onChanged: (bool? value) {
                    if (value != null) {
                       _handleAppSelection(app.packageName);
                    }
                  },
                  shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(5),
                      ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  secondary: app.icon == null
                      ? null
                      : CircleAvatar(backgroundImage: MemoryImage(app.icon!)),
                );
                },
                  separatorBuilder: (context, index) => const Divider(height: 3),
                ),
             ),),
         ]);

      }
}

