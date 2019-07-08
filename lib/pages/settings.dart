import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {

  Settings _settings;
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Street"
                ),
                controller: _streetController,
                validator: _formFieldValidator,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 150,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "City"
                      ),
                      controller: _cityController,
                      validator: _formFieldValidator,
                    ),
                  ),
                  Container(
                    width: 80,
                    margin: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "State"
                      ),
                      controller: _stateController,
                      validator: _formFieldValidator,
                    ),
                  ),
                  Container(
                    width: 100,
                    margin: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Zip Code"
                      ),
                      controller: _zipCodeController,
                      validator: _formFieldValidator,
                    ),
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone number",
                ),
                controller: _phoneNumberController,
                validator: _formFieldValidator,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: FlatButton(
                  child: Text('Save'),
                  onPressed: () async {
                    var _dbHelper = DbHelper.instance;
                    var db = await _dbHelper.database;
                    if (_formKey.currentState.validate()) {
                      var settings = Settings(
                        _streetController.text,
                        _cityController.text,
                        _stateController.text,
                        _zipCodeController.text,
                        _phoneNumberController.text
                      );

                      try {
                        await db.update('Settings', settings.toJson(), where: 'id = ?', whereArgs: [_settings.id]);
                      } catch(e) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Something went wrong, please try again.'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            );
                          }
                        );
                      }
                    }
                  },
                  textTheme: ButtonTextTheme.primary,
                )
              ),
              Divider(),
              Text("Why we need this information",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Text("We need an addresss where you want your order to be delivered, as well as a phone number in order to contact you for any additional information we might need.",
                style: TextStyle(
                  fontSize: 12
                ),
              )
            ],
          ),
        )
      )
    );
  }

  _getSettings() async {
    var _dbHelper = DbHelper.instance;
    var db = await _dbHelper.database;
    var map = await db.query('Settings');
    if (map.isNotEmpty) {
      _settings = Settings.fromJson(map[0]);
      _streetController.text = _settings.street;
      _cityController.text = _settings.city;
      _stateController.text = _settings.state;
      _zipCodeController.text = _settings.zipCode;
      _phoneNumberController.text = _settings.phoneNumber;
    }
  }

  String _formFieldValidator(String value) {
    if (value.isEmpty) return 'Required field';
  }
}