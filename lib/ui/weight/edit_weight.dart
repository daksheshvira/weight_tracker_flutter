import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weight_tracker/bloc/weight/weight_bloc.dart';
import 'package:weight_tracker/bloc/weight/weight_event.dart';
import 'package:weight_tracker/bloc/weight/weight_state.dart';
import 'package:weight_tracker/models/weight_model.dart';
import 'package:weight_tracker/ui/theme/colors.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_button.dart';
import 'package:weight_tracker/ui/widgets/primary_circular_progress.dart';
import 'package:weight_tracker/ui/widgets/primary_dialog.dart';
import 'package:weight_tracker/ui/widgets/primary_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditWeight extends StatefulWidget {
  Weight currentWeight;

  EditWeight({this.currentWeight});

  @override
  _EditWeightState createState() => _EditWeightState(currentWeight: currentWeight);
}

class _EditWeightState extends State<EditWeight> {
  TextEditingController kgController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();
  DateTime _dateTime;
  Weight currentWeight;
  String pictureUrl;
  File localImage;

  _EditWeightState({this.currentWeight});

  @override
  void initState() {
    super.initState();
    kgController.text = currentWeight.weightKg.toString();
    _dateTime = currentWeight.date.toDate();
    commentController.text = currentWeight.comment;
    pictureUrl = currentWeight.pictureUrl;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WeightBloc>(context);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Edit weight measurement",
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () {
              _showDialog(context, bloc);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildPhoto(context, bloc),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: PrimaryFormField(
                        controller: kgController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "St"),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((pickedDate) {
                          setState(() {
                            _dateTime = pickedDate;
                          });
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _dateTime == null
                                  ? Text(
                                      'Choose date',
                                      style:
                                          TextStyle(fontSize: 16.0, color: Colors.grey),
                                    )
                                  : Text(
                                      DateFormat.yMMMd().format(_dateTime),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                              Icon(Icons.calendar_today)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
                PrimaryFormField(
                  controller: commentController,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(labelText: "Comments"),
                ),
                SizedBox(
                  height: 30,
                ),
                BlocBuilder<WeightBloc, WeightState>(
                  builder: (ctx, state) {
                    if (state is AddingWeightState) {
                      return PrimaryCircularProgress();
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: PrimaryButton(
                          label: "Submit changes",
                          onPressed: () async {
                            await bloc.add(
                              WeightEditEvent(
                                id: currentWeight.id,
                                kg: int.parse(kgController.text),
                                comment: commentController.text,
                                date: _dateTime,
                                pictureUrl: pictureUrl,
                                imageFile: localImage,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                BlocListener<WeightBloc, WeightState>(
                  listenWhen: (prev, next) {
                    next == AddedWeightState;
                  },
                  child: Container(),
                  listener: (prev, next) {
                    if (next is AddedWeightState) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildPhoto(BuildContext context, WeightBloc bloc) {
    if (pictureUrl == "" && localImage == null) {
      return CircleAvatar(
        radius: 31,
        backgroundColor: WTColors.limeGreen,
        child: CircleAvatar(
          radius: 30,
          foregroundColor: WTColors.limeGreen,
          backgroundColor: WTColors.backgroundGrey,
          child: IconButton(
            icon: Icon(Icons.photo),
            onPressed: () {
              _getLocalImage(bloc);
            },
          ),
        ),
      );
    } else if (pictureUrl == null && localImage == null) {
      return CircleAvatar(
        radius: 31,
        backgroundColor: WTColors.limeGreen,
        child: CircleAvatar(
          radius: 30,
          foregroundColor: WTColors.limeGreen,
          backgroundColor: WTColors.backgroundGrey,
          child: IconButton(
            icon: Icon(Icons.photo),
            onPressed: () {
              _getLocalImage(bloc);
            },
          ),
        ),
      );
    } else if (pictureUrl != "" && pictureUrl != null) {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Image(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              image: NetworkImage(pictureUrl),
            ),
          ),
          FlatButton(
            child: Text(
              "Remove",
              style: TextStyle(color: WTColors.limeGreen),
            ),
            onPressed: () {
              setState(() {
                pictureUrl = "";
              });
            },
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Image(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              image: FileImage(localImage),
            ),
          ),
          FlatButton(
            child: Text(
              "Remove",
              style: TextStyle(color: WTColors.limeGreen),
            ),
            onPressed: () {
              setState(() {
                localImage = null;
              });
            },
          ),
        ],
      );
    }
  }

  _showDialog(BuildContext context, WeightBloc bloc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PrimaryDialog(
            content: Text("Delete measurement?"),
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
                  await bloc.add(
                    WeightRemovedEvent(weight: currentWeight),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  _getLocalImage(WeightBloc bloc) async {
    ImagePicker imagePicker = ImagePicker();

    final pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 90, maxWidth: 1000);

    setState(() {
      localImage = File(pickedFile.path);
    });
  }
}
