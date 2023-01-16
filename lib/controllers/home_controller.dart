import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionei/models/parking_spot_model.dart';
import 'package:estacionei/models/user_model.dart';
import 'package:estacionei/services/user_service.dart';
import 'package:mobx/mobx.dart';
import '../models/history_model.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  final _userService = UserService();

  @observable
  bool isLoading = true;

  @observable
  UserModel? userData;

  @observable
  ParkingSpotModel? spotActual;

  @observable
  HistoryModel? historyActual;

  @action
  void updateData({required Map<String, dynamic> data, bool isSpot = false, bool isBigData = false}){
    _userService.updateUserData(data: data, isSpot: isSpot, isBigData : isBigData).then((value){
      print('Sucesso!');
    }).catchError((e){
      print(e);
    });
  }

  @action
  Future<Stream<QuerySnapshot>> getUserDataStream({bool? filterName, bool? available, String? termo})async {
    return await _userService.getUserDataStream(filterName: filterName, available: available, termo:  termo);
  }

  @computed
  double get priceToPay => spotActual!.priceToPay(userData!.valueHour!);

  @action
  void saveHistory(){
    _userService.createHistory(historyActual: historyActual, spot: spotActual).then((value){
      _userService.createSpotHistory(spot: spotActual!, id: historyActual!.id);
    });
    updateData(data: ParkingSpotModel(id: spotActual!.id, name: spotActual!.name, available: true).toMap(), isSpot: true);
  }

}
