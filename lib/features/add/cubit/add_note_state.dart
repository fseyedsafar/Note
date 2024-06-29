part of 'add_note_cubit.dart';

@immutable
abstract class AddNoteState {}

class AddNoteInitial extends AddNoteState {}
class SuccessSave extends AddNoteState {}
class FailedSave extends AddNoteState {
  final String failedMessage;

  FailedSave(this.failedMessage);
}
