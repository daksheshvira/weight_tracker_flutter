import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:weight_tracker/models/weight_model.dart';

abstract class WeightEvent extends Equatable {}

class LoadWeightEvent extends WeightEvent {
  @override
  List<Object> get props => [];
}

class WeightAddedEvent extends WeightEvent {

  int kg;
  DateTime date;
  String comment;
  File imageFile;

  WeightAddedEvent({this.kg, this.date, this.comment, this.imageFile});

  @override
  List<Object> get props => [];
}

class WeightEditEvent extends WeightEvent {
  String id;
  int kg;
  DateTime date;
  String comment;
  File imageFile;
  String pictureUrl;

  WeightEditEvent(
      {this.id,
      this.kg,
      this.date,
      this.comment,
      this.imageFile,
      this.pictureUrl});

  @override
  List<Object> get props => [];
}

class WeightChangedEvent extends WeightEvent {
  @override
  List<Object> get props => [];
}

class WeightRemovedEvent extends WeightEvent {
  Weight weight;

  WeightRemovedEvent({this.weight});

  @override
  List<Object> get props => [];
}
