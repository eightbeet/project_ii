import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.account_circle,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        Expanded(
          child: ListView(
            children: [
              _buildSectionTitle('Theme'),
              _buildSwitchTile(
                title: 'Dark Mode',
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),

              // Notifications Setting
              _buildSectionTitle('Notifications'),
              _buildSwitchTile(
                title: 'Enable Notifications',
                value: isNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    isNotificationsEnabled = value;
                  });
                },
              ),

              // Language Setting
              _buildSectionTitle('Language'),
              _buildDropdownTile(
                title: 'Select Language',
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                items: ['English', 'Spanish', 'French', 'German'],
              ),
              
              Divider(),
              
              // About Section
              _buildSectionTitle('About'),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('App Info'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy Policy'),
                onTap: () {
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // Build switch tiles
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(
        value ? Icons.toggle_on : Icons.toggle_off,
        color: value
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondaryContainer,
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  // Build dropdown tiles
  Widget _buildDropdownTile({
    required String title,
    required String value,
    required Function(String?) onChanged,
    required List<String> items,
  }) {
    return ListTile(
      leading: Icon(Icons.language),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String lang) {
          return DropdownMenuItem<String>(
            value: lang,
            child: Text(lang),
          );
        }).toList(),
        icon: Icon(Icons.arrow_drop_down),
        underline: Container(),
      ),
    );
  }
}

