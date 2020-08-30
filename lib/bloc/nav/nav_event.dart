import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {}

class ChangeNavEvent extends NavEvent {
  ChangeNavEvent({this.index, this.dateTime});
  DateTime dateTime;

  int index;

  @override
  List<Object> get props => [index, dateTime];
}
