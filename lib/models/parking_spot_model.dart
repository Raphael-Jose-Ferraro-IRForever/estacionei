import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpotModel{
  String id;
  String? plate;
  String name;
  bool available;
  double? price;
  DateTime? entryTime;
  DateTime? exitTime;

  ParkingSpotModel({required this.id, this.exitTime, this.price, this.plate, required this.name, required this.available, this.entryTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plate': plate,
      'name': name,
      'available': available,
      'entryTime': entryTime,
      'exitTime': exitTime,
      'price': price
    };
  }

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpotModel(
      id: map['id'],
      plate: map['plate'],
      name: map['name'],
      available: map['available'],
      entryTime: map['entryTime'] != null ? (map['entryTime'] as Timestamp) .toDate() : null,
      exitTime: map['exitTime'] != null ? (map['exitTime'] as Timestamp) .toDate() : null,
      price: map['price']
    );
  }

  void inputVehicleInSpot(String plateValue){
    available = false;
    plate = plateValue;
    entryTime = DateTime.now();
  }

  void resetData(){
    available = true;
    plate = null;
    entryTime = null;
    price = null;
    exitTime = null;
  }

  double priceToPay(double valueHour){
    return entryTime!.difference(DateTime.now()).inSeconds.abs() / 3600.0 * valueHour;
  }

}