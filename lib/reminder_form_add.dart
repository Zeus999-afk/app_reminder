//NRP: 992024006
// Nama: Masyitah Nanda Yassril
// Deskripsi kode: QUIZ
// Tanggal kode dibuat: 31 Oktober 2024a

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_reminder/model.dart';
import 'package:app_reminder/restapi.dart';
import 'package:app_reminder/config.dart';

class ReminderFormAdd extends StatefulWidget {
  const ReminderFormAdd({super.key});

  @override
  ReminderFormAddState createState() => ReminderFormAddState();
}

class ReminderFormAddState extends State<ReminderFormAdd> {
  final title = TextEditingController();
  final deskripsi = TextEditingController();
  final tanggal_mulai = TextEditingController();

  String prioritas = 'Urgent';
  String alarm = '1 Jam sebelumnya';

  late Future<DateTime?> selectedDate;
  String date = "-";

  DataService ds = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Reminder You Need"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: title,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'What do you want to be remind of?'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: deskripsi,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                ),
                value: prioritas,
                onChanged: (String? newValue) {
                  setState(() {
                    prioritas = newValue!;
                  });
                },
                items: <String>['Urgent', 'Medium', 'Low']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            //  INI NANTI BUAT NENTUIN DIA UDAH SELESAI APA BELUM, DI CROSS KALAU UDAH SELESAI!!  DI END-RESULTs
            // ),
            // Padding(
            //     padding: Checkbox(
            //   checkColor: Colors.white,
            //   value: status,
            //   onChanged: (bool? value) {
            //     setState(() {
            //       isChecked = value!;
            //     });
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: tanggal_mulai,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pick a Date',
                ),
                onTap: () {
                  showDialogPicker(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                ),
                value: alarm,
                onChanged: (String? newValue) {
                  setState(() {
                    prioritas = newValue!;
                  });
                },
                items: <String>[
                  '1 jam sebelumnya',
                  '2 jam sebelumnya',
                  '1 hari sebelumnya'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    List response = jsonDecode(await ds.insertReminder(
                      appid,
                      title.text,
                      deskripsi.text,
                      tanggal_mulai.text,
                      prioritas,
                      alarm,
                    ));
                    List<AppFunctionalityModel> reminder = response
                        .map((e) => AppFunctionalityModel.fromJson(e))
                        .toList();

                    if (reminder.length == 1) {
                      Navigator.pop(context, true);
                    } else {
                      if (kDebugMode) {
                        print(response);
                      }
                    }
                  },
                  child: const Text(
                    "SAVE",
                    style:
                        TextStyle(color: Color.fromARGB(255, 2555, 255, 255)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogPicker(BuildContext context) {
    var date = DateTime.now();

    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime(date.year - 20, date.month, date.day),
      firstDate: DateTime(1980),
      lastDate: DateTime(date.year - 20, date.month, date.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    selectedDate.then((value) {
      setState(() {
        if (value == null) return;
        final DateFormat formatter = DateFormat('dd-MM-yyy');
        final String formattedDate = formatter.format(value);

        tanggal_mulai.text = formattedDate;
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
