// NRP: 992024006
// Nama: Masyitah Nanda Yassril
// Deskripsi kode: QUIZ
// Tanggal kode dibuat: 31 Oktober 2024a

import 'package:app_reminder/reminder_detail.dart';
import 'package:app_reminder/reminder_form_add.dart';
import 'package:app_reminder/reminder_list.dart';
import 'package:flutter/material.dart';
// import 'package:app_reminder/reminder_add.dart';
// import 'package:app_reminder/reminder_form.dart';
// import 'package:app_reminder/reminder.dart';
// import 'package:app_reminder/reminder_dorm_edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reminder',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 82, 9, 9)),
      ),
      home: const ReminderList(),
      routes: {
        'reminder_list': (context) => const ReminderList(),
        'reminder_form_add': (context) => const ReminderFormAdd(),
        // 'reminder_form_edit': (context) => const ReminderFormEdit(),
        'reminder_detail': (context) => const ReminderDetail(),
      },
    );
  }
}
