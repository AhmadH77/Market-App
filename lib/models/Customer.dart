//@dart=2.9
import 'package:location/location.dart';

class Customer {
  final int id;
  String firstName, lastName, phone, email, photo, type, password, lat, long;

  Customer(
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.photo,
    this.type,
    this.password, {
    this.lat,
    this.long,
  });
}
