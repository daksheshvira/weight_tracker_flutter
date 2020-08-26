import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/bloc/weight/weight_bloc.dart';
import 'package:weight_tracker/bloc/weight/weight_event.dart';
import 'package:weight_tracker/bloc/weight/weight_state.dart';
import 'package:weight_tracker/ui/theme/colors.dart';
import 'package:weight_tracker/ui/validators/textfield_validator.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_button.dart';
import 'package:weight_tracker/ui/widgets/primary_circular_progress.dart';
import 'package:weight_tracker/ui/widgets/primary_form_field.dart';

class AddWeight extends StatefulWidget {
  @override
  _AddWeightState createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController kgController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();
  DateTime _dateTime;
  bool noDate = false;
  File localImage;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WeightBloc>(context);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Add weight measurement",
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              if (localImage == null) SizedBox(height: 20),
              localImage == null
                  ? CircleAvatar(
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
                    )
                  : Column(
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
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 32.0,
                  right: 32.0,
                  bottom: 16.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: PrimaryFormField(
                            validator: TextFieldValidator.validate,
                            controller: kgController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Kg"),
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
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Theme.of(context).primaryColor,
                                      surface: Colors.grey,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ).then((pickedDate) {
                              setState(() {
                                _dateTime = pickedDate;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 32.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _dateTime == null
                                      ? Text(
                                          'Choose date',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey),
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
                          color: noDate ? Colors.red : Colors.white,
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        noDate ? "Choose a date" : "",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    PrimaryFormField(
                      controller: commentController,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(labelText: "Comments"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    BlocBuilder<WeightBloc, WeightState>(
                      builder: (ctx, state) {
                        if (state is AddingWeightState) {
                          return PrimaryCircularProgress();
                        } else {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: PrimaryButton(
                              label: "Submit weight",
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _dateTime != null
                                      ? bloc.add(
                                          WeightAddedEvent(
                                            kg: int.parse(kgController.text),
                                            date: _dateTime,
                                            comment: commentController.text,
                                            imageFile: localImage,
                                          ),
                                        )
                                      : setState(() {
                                          noDate = true;
                                        });
                                  kgController.text = "";
                                  _dateTime = null;
                                }
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
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
