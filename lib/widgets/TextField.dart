//@dart=2.9
import 'package:flutter/material.dart';
import 'package:market_app/translate/app_localizations.dart';

import '../constants.dart';

class TextFieldItem extends StatefulWidget {

  final TextEditingController controller;
  final String labelText;
  final String type;

  TextFieldItem({Key key , this.controller , this.labelText, this.type}) : super(key: key);

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldItem> {


  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {

    if(widget.type != 'password')
      setState(() {
        isObsecure = false;
      });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: (widget.type == 'price' || widget.type == 'smsCode' ) ?
          TextInputType.number
            : widget.type == 'phone'
            ?  TextInputType.phone
            : widget.type == 'email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        validator: (value) {
          if(value.isEmpty && widget.type != 'brand'){
            return AppLocalizations.getTranslated(context, 'required');
          }
          if(widget.type == 'password')
            return value.length > 8
                ? null
                : 'Enter a valid 8 Characters Password';
          if(widget.type == 'email' && (!value.contains('@') || !value.endsWith('.com')))
            return  'Enter a valid Email';
          if(widget.type == 'smsCode' && value.length == 0)
            return 'Please Enter the verification code';
          return null;
        },
        obscureText: isObsecure,
        controller: widget.controller,
        decoration: InputDecoration(
            suffixIcon: widget.type=='password'
            ?GestureDetector(

              child: Icon(
                  isObsecure ? Icons.visibility : Icons.visibility_off),
              onTap: () {
                print('test');
                setState(() {
                  isObsecure = !isObsecure;
                });
              },
            ): null,
            labelText: AppLocalizations.getTranslated(context, widget.labelText),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Constants.primaryColor , ),
                borderRadius: BorderRadius.all(Radius.circular(20)
                )
            ),
            border: OutlineInputBorder(
              // borderSide: BorderSide(color: Constants.primaryColor , ),
                borderRadius: BorderRadius.all(Radius.circular(20)
                )
            )
        ),
      ),
    );
  }
}
