import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_app/theme/theme_config.dart';
import 'package:flutter_book_app/utils/navigate.dart';
import 'package:flutter_book_app/view/screens/downloads.dart';
import 'package:flutter_book_app/view/screens/favorites.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late List settings;

  @override
  void initState() {
    super.initState();
    settings = [
      {
        'icon': Icons.download,
        'title': 'Downloads',
        'function': () => Navigate.pushPage(context, Downloads()),
      },
      {
        'icon': CupertinoIcons.heart,
        'title': 'Favorites',
        'function': () => Navigate.pushPage(context, Favorites()),
      },
      {
        'icon': CupertinoIcons.info,
        'title': 'About',
        'function': () => showAbout(),
      },
      {
        'title': 'Dark Mode',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: settings.length,
        itemBuilder: (BuildContext context, int index) {
          if (settings[index]['title'] == 'Dark Mode') {
            return _buildThemeSwitch(settings[index]);
          }
          return ListTile(
            onTap: settings[index]['function'],
            leading: Icon(
              settings[index]['icon'],
            ),
            title: Text(
              settings[index]['title'],
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  showAbout() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'About',
          ),
          content: Text(
            'A Simple App to read Free eBooks made by CharlyKeleb',
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeSwitch(Map item) {
    return ListTile(
      title: Text(
        "Dark Mode",
        style: TextStyle(
          fontWeight: FontWeight.w900,
        ),
      ),
      trailing: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => CupertinoSwitch(
          onChanged: (val) {
            notifier.toggleTheme();
          },
          value: notifier.dark!,
          activeColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
