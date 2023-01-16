import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionei/models/parking_spot_model.dart';
class HistoryModel {

  String id;
  double paid;
  double unPaid;
  DateTime? date;
  List<ParkingSpotModel> historyParking;

  HistoryModel({
    required this.id,
    required this.paid,
    this.unPaid = 0.0,
    required this.date,
    required this.historyParking,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'paid': this.paid,
      'unPaid': this.unPaid,
      'date': this.date
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      paid: map['paid'] as double,
      unPaid: map['unPaid'] as double,
      date: map['date'] != null ? (map['date'] as Timestamp).toDate() : null,
      historyParking: map['historyParking'] != null ? List<ParkingSpotModel>.from(map['historyParking'].map((e)=>ParkingSpotModel.fromMap(e))) : []
    );
  }

  void updateValues(ParkingSpotModel spot){
    historyParking.add(spot);
    paid += spot.price!;
  }

}