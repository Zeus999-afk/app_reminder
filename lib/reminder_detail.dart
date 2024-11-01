//NRP: 992024006
// Nama: Masyitah Nanda Yassril
// Deskripsi kode: QUIZ
// Tanggal kode dibuat: 31 Oktober 2024a

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_reminder/model.dart';
import 'package:app_reminder/restapi.dart';
import 'package:app_reminder/config.dart';

class ReminderDetail extends StatefulWidget {
  const ReminderDetail({Key? key}) : super(key: key);

  @override
  ReminderDetailState createState() => ReminderDetailState();
}

class ReminderDetailState extends State<ReminderDetail> {
  DataService ds = DataService();
  late ValueNotifier<int> _notifier;

  List<AppFunctionalityModel> reminder = [];
  selectIdReminder(String id) async {
    List data = [];
    data = jsonDecode(
        await ds.selectId(token, project, 'reminder_app', appid, id));
    reminder = data.map((e) => AppFunctionalityModel.fromJson(e)).toList();
  }

  Future reloadDataReminder(dynamic value) async {
    setState(() {
      final args = ModalRoute.of(context)?.settings.arguments as List<String>;

      selectIdReminder(args[0]);
    });
  }

  @override
  void initState() {
    _notifier = ValueNotifier<int>(0);
    super.initState();
  }

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminder Detail"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print(reminder);
                }
                Navigator.pushNamed(context, 'reminder_form_edit',
                    arguments: [args[0]]).then(reloadDataReminder);
              },
              child: const Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text("Remove this data?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("CANCEL"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            bool response = await ds.removeId(
                                token, project, 'reminder_app', appid, args[0]);
                            if (response) {
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text("REMOVE"),
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.delete_forever,
                size: 26.0,
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<dynamic>(
          future: selectIdReminder(args[0]),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                {
                  return const Text('None');
                }
              case ConnectionState.waiting:
                {
                  return const Center(child: CircularProgressIndicator());
                }
              case ConnectionState.active:
                {
                  return const Text('Active');
                }
              case ConnectionState.done:
                {
                  return ListView(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.black12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    reminder[0].title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(reminder[0].title),
                          subtitle: const Text(
                            "title",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.book_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(reminder[0].description),
                          subtitle: const Text(
                            "Description",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(reminder[0].tanggal_mulai),
                          subtitle: const Text(
                            "Reminder dimulai",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(reminder[0].prioritas),
                          subtitle: const Text(
                            "Priority",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.priority_high,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(reminder[0].alarm),
                          subtitle: const Text(
                            "Alarm",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.alarm,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      )
                    ],
                  );
                }
            }
          }),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}
