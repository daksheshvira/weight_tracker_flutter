import 'package:equatable/equatable.dart';
import 'package:weight_tracker/models/weight_model.dart';

abstract class WeightState extends Equatable {}

class WeightInitialState extends WeightState {
  List<Weight> weight;
  WeightInitialState({this.weight});

  @override
  List<Object> get props => [weight];
}

class AddingWeightState extends WeightState {
  @override
  List<Object> get props => [];
}

class AddedWeightState extends WeightState {
  @override
  List<Object> get props => [];
}

class WeightChangedState extends WeightState {
  List<Weight> weight;
  WeightChangedState({this.weight});

  @override
  List<Object> get props => [weight];
}
