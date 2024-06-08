import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:note/db/database.dart';
import 'package:note/model/note.dart';

import '../utils/app_color.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  String title = "";
  String description = "";
  int responseNoteId = -1;
  String date = "";
  String time = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.color,
        ),
        title: const Text(
          "add note",
          style: TextStyle(
            color: AppColor.color,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("custom date"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("custom time"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              showDatePicker();
            } else if (value == 1) {
              showTimePicker();
            }
          }),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'enter a title',
                hintStyle: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: const TextStyle(color: Colors.white70, fontSize: 22),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'enter a description',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 22)),
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveNote();
        },
        // tooltip: 'Increment',
        child: const Icon(Icons.done),
      ),
    );
  }

  void saveNote() {
    handleDate();
    handleTime();
    var note = Note(0, title, description, date, time);
    var result = NoteDataBase.db.insertNote(note);
    result.then((value) => responseNoteId = value);
    note.id = responseNoteId;
    //todo show loading
    if (responseNoteId > 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('successful'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('failed'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2000, 1, 1),
        maxTime: DateTime(2025, 12, 29),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        this.date = date.toString();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.fa);
  }

  void showTimePicker() {
    DatePicker.showTimePicker(context,
        showTitleActions: true, onChanged: (time) {}, onConfirm: (time) {
      setState(() {
        this.time = time.toString();
      });
    }, currentTime: DateTime.now());
  }

  void handleDate() {
    if (date.isEmpty) {
      date = DateTime.now().toString();
    }
  }

  void handleTime() {
    if (time.isEmpty) {
      time = DateTime.now().toString();
    }
  }
}
