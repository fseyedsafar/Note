import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:note/features/add/cubit/add_note_cubit.dart';

import '../../utils/app_color.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddNoteCubit>(
      create: (context) => AddNoteCubit(),
      child: BlocListener(
        listener: (BuildContext context, state) {
          switch (state) {
            case SuccessSave:
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Successful'),
                  backgroundColor: Colors.green,
                ));
                Navigator.pop(context, true);
                break;
              }
            case FailedSave:
              {
                String message = (state as FailedSave).failedMessage;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.red,
                ));
                break;
              }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: AppColor.primaryColor,
            ),
            title: const Text(
              "add note",
              style: TextStyle(
                color: AppColor.primaryColor,
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
                    getCubit(context).titleChanged(value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white70, fontSize: 22),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'enter a description',
                      hintStyle:
                          TextStyle(color: Colors.white70, fontSize: 22)),
                  onChanged: (value) {
                    getCubit(context).descriptionChanged(value);
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              getCubit(context).saveNote();
            },
            child: const Icon(Icons.done),
          ),
        ),
      ),
    );
  }

  AddNoteCubit getCubit(BuildContext context) => context.read<AddNoteCubit>();

  void showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2000, 1, 1),
        maxTime: DateTime(2025, 12, 29),
        onChanged: (date) {}, onConfirm: (date) {
      getCubit(context).dateChanged(date.toString());
    }, currentTime: DateTime.now(), locale: LocaleType.fa);
  }

  void showTimePicker() {
    DatePicker.showTimePicker(context,
        showTitleActions: true, onChanged: (time) {}, onConfirm: (time) {
      getCubit(context).timeChanged(time.toString());
    }, currentTime: DateTime.now());
  }
}
