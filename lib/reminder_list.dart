//ini buat dipake nanti
//NRP: 992024006
// Nama: Masyitah Nanda Yassril
// Deskripsi kode: QUIZ
// Tanggal kode dibuat: 31 Oktober 2024a

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:app_reminder/model.dart';
import 'package:app_reminder/restapi.dart';
import 'package:app_reminder/config.dart';

class ReminderList extends StatefulWidget {
  const ReminderList({Key? key}) : super(key: key);

  @override
  ReminderListState createState() => ReminderListState();
}

class ReminderListState extends State<ReminderList> {
  final searchKeyword = TextEditingController();
  bool searchStatus = false;

  DataService ds = DataService();

  List data = [];
  List<AppFunctionalityModel> reminder = [];
  List<AppFunctionalityModel> search_data = [];
  List<AppFunctionalityModel> search_data_pre = [];

  selectAllReminder() async {
    data =
        jsonDecode(await ds.selectAll(token, project, 'reminder_app', appid));
    reminder = data.map((e) => AppFunctionalityModel.fromJson(e)).toList();

    setState(() {
      reminder = reminder;
    });
  }

  void filterReminder(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      search_data = data.map((e) => AppFunctionalityModel.fromJson(e)).toList();
    } else {
      search_data_pre =
          data.map((e) => AppFunctionalityModel.fromJson(e)).toList();
      search_data = search_data_pre
          .where((user) =>
              user.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    //refresh
    setState(() {
      reminder = search_data;
    });
  }

  Future reloadDataReminder(dynamic value) async {
    setState(() {
      selectAllReminder();
    });
  }

  @override
  void initState() {
    selectAllReminder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !searchStatus ? const Text('Daftar Reminder') : search_field(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'reminder_form_add')
                    .then(reloadDataReminder);
              },
              child: const Icon(
                Icons.add_box_rounded,
                size: 26.0,
              ),
            ),
          ),
          search_icon(),
        ],
      ),
      body: ListView.builder(
        itemCount: reminder.length,
        itemBuilder: (context, index) {
          final item = reminder[index];
          return ListTile(
              // title: Text(item.name),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              // subtitle: Text(item.birthday),
              onTap: () {
                Navigator.pushNamed(context, 'reminder_detail',
                    arguments: [item.id]).then(reloadDataReminder);
              });
        },
      ),
    );
  }

  Widget search_icon() {
    return !searchStatus
        ? Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  searchStatus = true;
                });
              },
              child: const Icon(
                Icons.search_rounded,
                size: 26.0,
              ),
            ), //Gesture Detection
          )
        : Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  searchStatus = false;
                });
              },
              child: const Icon(
                Icons.close_rounded,
                size: 26.0,
              ),
            ),
          );
  }

  Widget search_field() {
    return TextField(
      controller: searchKeyword,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      onChanged: (value) => filterReminder(value),
      decoration: const InputDecoration(
        hintText: 'Search your reminder',
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
        ),
      ),
    );
  }
}
