import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_event.dart';
import 'package:weight_tracker/bloc/weight/weight_bloc.dart';
import 'package:weight_tracker/bloc/weight/weight_event.dart';
import 'package:weight_tracker/bloc/weight/weight_state.dart';
import 'package:weight_tracker/models/weight_model.dart';
import 'package:weight_tracker/ui/weight/add_weight.dart';
import 'package:weight_tracker/ui/weight/weight_details.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_circular_progress.dart';
import 'package:weight_tracker/ui/widgets/primary_dialog.dart';

class WeightPage extends StatelessWidget {
  Weight currentWeight;

  @override
  Widget build(BuildContext context) {
    WeightBloc weightBloc = BlocProvider.of<WeightBloc>(context)
      ..add(
        LoadWeightEvent(),
      );
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Weight",
        implyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showSignoutDialog(context, authBloc);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              BlocBuilder<WeightBloc, WeightState>(
                builder: (ctx, state) {
                  if (state is WeightInitialState) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PrimaryCircularProgress(),
                    );
                  } else if (state is WeightChangedState) {
                    if (state.weight.length == 0) {
                      return Column(
                        children: [
                          SizedBox(height: 24),
                          Text(
                            "You haven't added any measurements yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.weight.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            onTap: () {
                              currentWeight = state.weight[i];
                              _navigateToDetails(context, currentWeight);
                            },
                            leading: _showIcon(context, i, state),
                            title: Text(
                                "${state.weight[i].weightKg}kg"),
                            subtitle: Text(
                                "${DateFormat.yMMMd().format(state.weight[i].date.toDate())}"),
                            trailing: IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: () {},
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddWeight(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _showIcon(BuildContext context, int i, state) {
    if (i == state.weight.length - 1) {
      return Icon(
        Icons.flag,
        color: Colors.grey,
      );
    }
    if (i >= 0 && i < state.weight.length - 1) {
      if (state.weight[i].weightKg > state.weight[i + 1].weightKg) {
        return Icon(
          Icons.arrow_upward,
          color: Colors.red,
        );
      } else if (state.weight[i].weightKg == state.weight[i + 1].weightKg) {
        return Icon(
          Icons.minimize,
          color: Colors.yellow,
        );
      } else {
        return Icon(
          Icons.arrow_downward,
          color: Theme.of(context).primaryColor,
        );
      }
    }
  }

  _openAddWeight(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddWeight();
        },
      ),
    );
  }

  _showSignoutDialog(BuildContext context, AuthBloc authBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrimaryDialog(
          content: Text("Are you sure you want to logout?"),
          actions: [
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              onPressed: () async {
                authBloc.add(SignoutEvent());
                Navigator.pop(context);
                Navigator.pop(context);

//                await Navigator.pushReplacement(
//                    context,
//                    PageTransition(
//                        type: PageTransitionType.fade, child: WeightTracker()));
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  _navigateToDetails(BuildContext context, Weight currentWeight) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return WeightDetails(currentWeight: currentWeight);
      }),
    );
  }
}
