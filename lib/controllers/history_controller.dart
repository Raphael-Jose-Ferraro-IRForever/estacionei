import 'package:estacionei/global.dart';
import 'package:estacionei/models/history_model.dart';
import 'package:estacionei/models/parking_spot_model.dart';
import 'package:mobx/mobx.dart';

import '../services/user_service.dart';
part 'history_controller.g.dart';

class HistoryController = HistoryControllerBase with _$HistoryController;

abstract class HistoryControllerBase with Store {
  HistoryControllerBase(){
    getHistory();
  }
  final _userService = UserService();

  @computed
  HistoryModel? get history => globalHome.historyActual;

  @observable
  List<ParkingSpotModel> spots = [];

  @action
  Future<void> getHistory({DateTime? data}) async{
    data ??= DateTime.now();
    var aux = await _userService.getHistory(data: data);
    if(aux != null) {
      globalHome.historyActual = aux;
      getStopsHistory(id: history!.id);
    }
  }

  @action
  Future<void> getStopsHistory({required String id}) async{
    var aux = await _userService.getSpots(isHistory: true, id: id);
    if(aux != null) {
      spots = aux;
    }
  }
}