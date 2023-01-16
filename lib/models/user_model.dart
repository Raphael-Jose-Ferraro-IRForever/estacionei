import 'parking_spot_model.dart';
import 'history_model.dart';

class UserModel{

  String? uid;
  int? quantGroups;
  int? quantParkingSpot;
  double? valueHour;
  List<ParkingSpotModel>? spots;
  List<HistoryModel>? histories;


  UserModel({
    this.uid,
    this.valueHour,
    this.quantParkingSpot,
    this.quantGroups,
    this.spots,
    this.histories
  });

  Map<String, dynamic> toBasicMap() {
    return {
      'quantGroups': quantGroups,
      'quantParkingSpot': quantParkingSpot,
      'valueHour': valueHour
    };
  }

  Map<String, dynamic> toIncompleteMap() {
    return {
      'uid': uid,
      'quantGroups': quantGroups,
      'quantParkingSpot': quantParkingSpot,
      'valueHour': valueHour,
      'history' : null
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      quantGroups: map['quantGroups'],
      quantParkingSpot: map['quantParkingSpot'],
      valueHour: map['valueHour']
    );
  }

  void generateData(String uId){
    uid = uId;
    quantGroups = 2;
    quantParkingSpot = 2;
    valueHour = 1.0;
    spots = _generateParkingSpots();
    histories = [];
  }

  void setValues(int quantGroupsValue, int quantParkingValue, double value){
    quantGroups = quantGroupsValue;
    quantParkingSpot = quantParkingValue;
    valueHour = value;
  }

  _generateParkingSpots() {
    var number = 0;
      return List<ParkingSpotModel>.generate(
          quantParkingSpot! * quantGroups!, (index) {
        var leter =
        String.fromCharCode(index ~/ quantParkingSpot! + 65)
            .toUpperCase();
        number = number != quantParkingSpot ? number + 1 : 1;
        return ParkingSpotModel(
            id: '0', name: '$leter$number', available: true);
      });
  }
  void addSpots(){
    var number = 0;
    var quantCopies = 0;
    var aux = List<ParkingSpotModel>.generate(quantParkingSpot! * quantGroups!, (index) {
      var leter = String.fromCharCode(index ~/ quantParkingSpot! + 65)
          .toUpperCase();
      number = number != quantParkingSpot ? number + 1 : 1;
      if(quantCopies < spots!.length && spots![quantCopies].name == '$leter$number'){
        quantCopies++;
        return spots![quantCopies-1];
      }
      return ParkingSpotModel(id: '0', name: '$leter$number', available: true);
    });
    spots = aux;
  }
}