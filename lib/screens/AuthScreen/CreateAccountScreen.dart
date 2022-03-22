import 'dart:developer';

import 'package:data_collector/constants/color.dart';
import 'package:data_collector/constants/strings.dart';
import 'package:data_collector/services/db.service.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  final GlobalKey<FormState> _dynFormKey = GlobalKey<FormState>();

  bool _isSubmitted = false;
  bool passVisibility = false;
  bool confPassVisibility = false;

  DBService db = DBService();
  Map<String, String> createAcc = {};

  _notify(bool isError, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: (isError) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(CustomColors.ASSETS_DARK),
        textColor: Colors.black
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body:  Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500)),

            const SizedBox(height: 50),



            Form(
              key: _dynFormKey,
                child: Column(
              children: [
                TextFormField(
                  onSaved: (value) {

                    createAcc['user_name'] = value!;

                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {

                      return "Username Required";

                    }

                    if (value.length < 3) {

                      return "Minimum 3 characters";

                    }

                    if (value.length > 50) {

                      return "Maximum 40 characters";

                    }

                    if (!value.contains(RegExp(r'^[^`~!@#$%^&*()_+={}\[\]|\\:;“’<,>.?๐฿]*$'))) {

                      return "Should not contain any symbols";

                    }

                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(CustomColors.ASSETS_DARK)),
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(CustomColors.ASSETS_DARK))),
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.white),
                    helperStyle: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  onSaved: (value) {

                    createAcc['password'] = value!;

                  },
                  onChanged: (value) {
                    createAcc['password'] = value;
                  },
                  validator: (value) {

                    if (value == null || value.isEmpty) {

                      return "Password required";

                    }

                    if (value.length < 3) {

                      return "Minimum 3 characters";

                    }

                    if (value.length > 50) {

                      return "Maximum 40 characters";

                    }

                    return null;

                  },
                  obscureText: !passVisibility,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(CustomColors.ASSETS_DARK)),
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(CustomColors.ASSETS_DARK))),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    helperStyle: const TextStyle(color: Colors.white),
                    prefixIcon: IconButton(onPressed: () {
                      setState(() {
                        passVisibility = !passVisibility;
                      });
                    }, icon: Icon((passVisibility) ? Icons.visibility_off : Icons.visibility, color: Colors.white,))
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  validator: (value) {

                    if (value == null || value.isEmpty) {

                      return "Password required";

                    }

                    if (value != createAcc['password']) {

                      return "Password did not match";
                    }

                    return null;

                  },
                  obscureText: !confPassVisibility,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(

                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(CustomColors.ASSETS_DARK)),
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(CustomColors.ASSETS_DARK))),
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    helperStyle: const TextStyle(color: Colors.white),
                    prefixIcon: IconButton(onPressed: () {
                      setState(() {
                        confPassVisibility = !confPassVisibility;
                      });
                    }, icon: Icon((confPassVisibility) ? Icons.visibility_off : Icons.visibility, color: Colors.white,))
                  ),
                ),

                const SizedBox(height: 15),

                Visibility(

                  visible: !_isSubmitted,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isSubmitted = true;
                          });
                          if (_dynFormKey.currentState!.validate()) {
                            _dynFormKey.currentState!.save();

                            var hashedPassword = DBCrypt().hashpw(createAcc['password']!, DBCrypt().gensalt());

                            createAcc['password'] = hashedPassword;

                            await db.insertData(TableNames.USERS, createAcc).then((value) => Navigator.pushReplacementNamed(context, RouteStrings.HOME)).catchError((error) {
                              _notify(true, 'Internal Error');
                            });

                          }

                          setState(() {
                            _isSubmitted = false;
                          });



                        }, child: const Text('Create Account')),
                  ),
                ),
                Visibility(
                    visible: _isSubmitted,
                    child: const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )),
              ],
            ))
            
          ],
        ),
      )
    ),
  );
}