import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:note/utils/defult_value.dart';

import '../../../db/database.dart';
import '../../../model/note.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  String _title = "";
  String _description = "";
  String _date = DefaultValue.date;
  String _time = DefaultValue.time;

  AddNoteCubit() : super(AddNoteInitial());

  void titleChanged(String updateTitle) {
    _title = updateTitle;
  }

  void descriptionChanged(String updateDescription) {
    _description = updateDescription;
  }

  void dateChanged(String updateDate) {
    _date = updateDate;
  }

  void timeChanged(String updateTimer) {
    _time = updateTimer;
  }

  void saveNote() {
    if(_description.isEmpty){
      emit(FailedSave("The description cannot be empty"));
    }else {
      NoteDataBase.db.insertNote(Note(0, _title, _description, _date, _time)).then((insertId) => {
        if(insertId > 0){
          emit(SuccessSave())
        }else{
          emit(FailedSave("Failed"))
        }
      });
    }
  }
}
