import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/weight/weight_bloc.dart';
import 'package:weight_tracker/bloc/weight/weight_event.dart';
import 'package:weight_tracker/bloc/weight/weight_state.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_circular_progress.dart';
import 'package:weight_tracker/ui/widgets/summary_card.dart';

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WeightBloc weightBloc = BlocProvider.of<WeightBloc>(context)
      ..add(LoadWeightEvent());

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Summary",
        implyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<WeightBloc, WeightState>(
                    builder: (ctx, state) {
                      if (state is WeightInitialState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PrimaryCircularProgress(),
                        );
                      } else if (state is WeightChangedState) {
                        var lastGain;
                        var totalGain;
                        var currentWeight;
                        var firstMeasurement;
                        if (state.weight.length == 0) {
                          return Text(
                            "Add some weights to see your stats",
                            style: TextStyle(color: Colors.grey),
                          );
                        } else {
                          currentWeight = "${state.weight[0].weightKg}kg";
                          firstMeasurement = "${state.weight.last.weightKg}kg";
                          state.weight.length == 1
                              ? lastGain = 0
                              : lastGain = ((state.weight[0].weightKg)) -
                                  ((state.weight[1].weightKg));
                          totalGain = ((state.weight[0].weightKg)) -
                              ((state.weight.last.weightKg));

                          return Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Your stats",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 110,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SummaryCard(
                                      title: "Recent weight",
                                      subtitle: currentWeight,
                                      subtitleColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(width: 10),
                                    SummaryCard(
                                      title: "Last gain/loss",
                                      subtitle: "$lastGain kg",
                                      subtitleColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 110,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SummaryCard(
                                      title: "First measurement",
                                      subtitle: firstMeasurement,
                                      subtitleColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(width: 10),
                                    SummaryCard(
                                        title: "Total gain/loss",
                                        subtitle: "$totalGain kg",
                                        subtitleColor:
                                            Theme.of(context).primaryColor),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        }
                      } else {
                        return Text(
                          "You haven't added any measurements yet",
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
