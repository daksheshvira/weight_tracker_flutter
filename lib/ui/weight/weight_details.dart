import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/weight/weight_bloc.dart';
import 'package:weight_tracker/bloc/weight/weight_state.dart';
import 'package:weight_tracker/models/weight_model.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/ui/theme/colors.dart';
import 'package:weight_tracker/ui/weight/edit_weight.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/summary_card.dart';

class WeightDetails extends StatelessWidget {
  Weight currentWeight;

  WeightDetails({this.currentWeight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: DateFormat.yMMMd().format(currentWeight.date.toDate()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            currentWeight.pictureUrl != null && currentWeight.pictureUrl != ""
                ? Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(currentWeight.pictureUrl),
                    ),
                  )
                : Container(
                    color: WTColors.darkGrey,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Icon(Icons.photo),
                  ),
            SizedBox(height: 30),
            Container(
              color: WTColors.darkGrey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Weight",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      currentWeight.weightKg.toString() +
                          " kg",
                      style: TextStyle(fontSize: 24.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Divider(),
                    ),
                    Text(
                      "Comment",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(currentWeight.comment ?? ""),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return EditWeight(currentWeight: currentWeight);
            }),
          );
        },
      ),
    );
  }
}
