import 'package:flutter/material.dart';
import 'package:note/db/database.dart';
import 'package:note/model/note.dart';
import 'package:note/utils/app_color.dart';
import 'package:share/share.dart';

class DetailNotePage extends StatefulWidget {
  final Note note;

  const DetailNotePage({Key? key, required this.note}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailNotePage(note: note);
}

class _DetailNotePage extends State<DetailNotePage> {
  final Note note;
  var isInEdit = false;
  String newTitle = '';
  String newDescription = '';
  final FocusNode _focusNode = FocusNode();

  _DetailNotePage({required this.note});

  @override
  void initState() {
    super.initState();
    newTitle = note.title;
    newDescription = note.description;
    // _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // _focusNode.requestFocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "note detail",
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
          iconTheme: const IconThemeData(
            color: AppColor.primaryColor,
          ),
          backgroundColor: Colors.black,
          actions: [
            Visibility(
              visible: isInEdit,
              child: IconButton(
                  onPressed: () {
                    updateNote();
                    setState(() {
                      isInEdit = false;
                    });
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                  )),
            ),
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("share"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("remove"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                shareNote();
              } else if (value == 1) {
                removeNote(context);
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
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
                readOnly: !isInEdit,
                enabled: isInEdit,
                initialValue: note.title,
                onChanged: (value) {
                  setState(() {
                    newTitle = value;
                  });
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  getDateFormat(),
                  style: const TextStyle(color: Colors.white24, fontSize: 20),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 22),
                readOnly: !isInEdit,
                enabled: isInEdit,
                initialValue: note.description,
                focusNode: _focusNode,
                onChanged: (value) {
                  setState(() {
                    newDescription = value;
                  });
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: !isInEdit,
          child: FloatingActionButton(
            onPressed: () {
              _focusNode.requestFocus();
              setState(() {
                isInEdit = true;
              });
            },
            child: const Icon(Icons.edit),
          ),
        ));
  }

  void updateNote() {
    note.title = newTitle;
    note.description = newDescription;
    NoteDataBase.db.updateNote(note);
  }

  void shareNote() {
    Share.share(note.description, subject: 'share note');
  }

  void removeNote(BuildContext context) {
    NoteDataBase.db.deleteNote(note.id);
    Navigator.pop(context, true);
  }

  String getDateFormat() {
    if (note.date.isNotEmpty) {
      return note.date.substring(0, 10);
    } else {
      return '';
    }
    // String date = DateFormat('yyyy/MM/dd').format(DateTime.now());
  }
}
