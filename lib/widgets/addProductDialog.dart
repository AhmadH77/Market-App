//@dart=2.9
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/pages/store.dart';
import 'package:market_app/process/apiCalls.dart';
import 'package:market_app/translate/app_localizations.dart';

import 'TextField.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  ImagePicker _picker = ImagePicker();
  XFile _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
              child: Text(
                AppLocalizations.getTranslated(context, 'addProduct'),
                style: TextStyle(
                  height: 2.5,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: _imageFile != null
                        ? Image.file(File(_imageFile.path))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  pickImage(ImageSource.gallery);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Icon(
                                          Icons.photo,
                                        ),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  pickImage(ImageSource.camera);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Icon(Icons.add_a_photo_outlined),
                                      )),
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldItem(
                    type: 'name',
                    controller: name,
                    labelText: AppLocalizations.getTranslated(context, 'Name'),
                  ),
                  TextFieldItem(
                    type: 'category',
                    controller: category,
                    labelText:
                        AppLocalizations.getTranslated(context, 'Category'),
                  ),
                  TextFieldItem(
                    type: 'brand',
                    controller: brand,
                    labelText: AppLocalizations.getTranslated(context, 'Brand'),
                  ),
                  TextFieldItem(
                    type: 'price',
                    controller: price,
                    labelText: AppLocalizations.getTranslated(context, 'Price'),
                  ),
                  TextFieldItem(
                    type: 'model',
                    controller: model,
                    labelText: AppLocalizations.getTranslated(context, 'model'),
                  ),
                  TextFieldItem(
                    type: 'description',
                    controller: description,
                    labelText:
                        AppLocalizations.getTranslated(context, 'prodDesc'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Constants.primaryColor,
        label: Text(AppLocalizations.getTranslated(context, 'confirm'),
            style: TextStyle(
                color: Colors.blueGrey[300], fontWeight: FontWeight.bold)),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            showDialog(
              context: context,
              builder: (context) {
                return SpinKitCubeGrid(
                  color: Constants.primaryColor,
                );
              },
            );
            var response = await APICalls(context).addProduct(
                Product(
                    name: name.text,
                    description: description.text,
                    model: model.text,
                    brand: brand.text,
                    category: category.text,
                    price: double.parse(price.text)),
                _imageFile);
            Navigator.pop(context);
            if (response == 'success')
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Store();
                  },
                ),
              );
          }
        },
      ),
    );
  }

  pickImage(source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print('pickImage catch $e');
    }
  }
}
