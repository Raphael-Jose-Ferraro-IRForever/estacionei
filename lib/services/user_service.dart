import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionei/global.dart';
import 'package:estacionei/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/parking_spot_model.dart';
import '../models/history_model.dart';

class UserService {
  late final _currentUser = FirebaseAuth.instance.currentUser;
  final _usersDock = FirebaseFirestore.instance.collection('users');

  Future<bool> userExist() async {
    return await _usersDock.doc(_currentUser!.uid).get().then((document) {
      if (document.exists) {
        return true;
      }
      return false;
    }).catchError((e) {
      print(e);
      throw (e);
    });
  }

  Future<void> registerUser() async {
    var userData = UserModel();
    userData.generateData(_currentUser!.uid);
    globalHome.userData = userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .set(userData.toBasicMap())
        .catchError((error) => print("Failed to add user: $error"));
    updateSpots(list: userData.spots!);
  }

  void updateSpots(
      {required List<ParkingSpotModel> list, bool isUpdate = false}) async {
    var db = FirebaseFirestore.instance;
    var batch = db.batch();
    if (isUpdate) {
      List<ParkingSpotModel> oldSpots = [];
      await getSpots().then((value) {
        oldSpots = value!;
      });
      for (var spot in oldSpots) {
        var docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('spots')
            .doc(spot.id);
        batch.delete(docRef);
      }
      for (var e in list) {
        var docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('spots');
        if (e.id == '0') {
          e.id = docRef.doc().id;
        }
        var data = e.toMap();
        batch.set(docRef.doc(e.id), data);
      }
      batch.commit();
      return;
    }
    for (var e in list) {
      var docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('spots')
          .doc();
      e.id = docRef.id;
      var data = e.toMap();
      batch.set(docRef, data);
    }
    batch.commit();
  }

  Future<UserModel?> getUserData() async {
    return await _usersDock.doc(_currentUser!.uid).get().then((document) {
      if (document.exists) {
        return UserModel.fromMap(document.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      print(e);
      throw (e);
    });
  }

  Future<HistoryModel?> getHistory({required DateTime data}) async {
    return await _usersDock
        .doc(_currentUser!.uid)
        .collection('histories')
        .where('date', isLessThan: data)
        .where('date',
            isGreaterThan:
                DateTime.now().subtract(Duration(hours: DateTime.now().hour)))
        .limit(1)
        .get()
        .then((document) {
      if (document.docs.isNotEmpty && document.docs.first.exists) {
        return HistoryModel.fromMap(document.docs.first.data());
      }
    }).catchError((e) {
      print(e);
      throw (e);
    });
  }

  Future<List<ParkingSpotModel>?> getSpots(
      {bool isHistory = false, String? id}) async {
    var ref = isHistory
        ? _usersDock.doc(_currentUser!.uid).collection('histories').doc(id).collection('spots')
        : _usersDock.doc(_currentUser!.uid).collection('spots');

    return await ref.get().then((document) {
      if (document.docs.isNotEmpty) {
        return List<ParkingSpotModel>.from(
            document.docs.map((e) => ParkingSpotModel.fromMap(e.data())));
      }
    }).catchError((e) {
      print(e);
      throw (e);
    });
  }

  Future<Stream<QuerySnapshot<Object?>>> getUserDataStream(
      {bool? filterName, bool? available, String? termo}) async {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('spots')
        .orderBy('name');

    if (available != null) {
      query = query.where('available', isEqualTo: available);
      return query.snapshots();
    }
    if (filterName != null && termo!.isNotEmpty) {
      if (filterName) {
        query = query.where('name', isEqualTo: termo.toUpperCase());
        return query.snapshots();
      }
      query = query.where('plate', isEqualTo: termo.toUpperCase());
      return query.snapshots();
    }

    return query.snapshots();
  }

  Future<String> updateUserData(
      {required Map<String, dynamic> data,
      bool isSpot = false,
      bool isBigData = false}) async {
    if (isBigData) {
      updateSpots(list: globalHome.userData!.spots!, isUpdate: true);
    }
    if (isSpot) {
      return _usersDock
          .doc(_currentUser!.uid)
          .collection('spots')
          .doc(data['id'])
          .update(data)
          .then((value) => 'Dados atualizados!')
          .catchError((error) => 'Erro ao atualizar!');
    }
    return _usersDock
        .doc(_currentUser!.uid)
        .update(data)
        .then((value) => 'Dados atualizados!')
        .catchError((error) => 'Erro ao atualizar!');
  }
  Future<String> createHistory({HistoryModel? historyActual, ParkingSpotModel? spot}) async{
    var hasHistory = await getHistory(data: DateTime.now());
    var ref = _usersDock.doc(_currentUser!.uid).collection('histories').doc();
    if(hasHistory != null) {
      hasHistory.paid += spot!.price!;
      return await _usersDock.doc(_currentUser!.uid).collection('histories').doc(hasHistory.id)
          .update(hasHistory.toMap())
          .then((value) => 'Sucesso ao finalizar!')
          .catchError((error) => 'Falha ao salvar!');
    }
    var history = historyActual;
      history ??= HistoryModel(id: ref.id,
          paid: spot!.price!,
          date: DateTime.now(),
          historyParking: [spot]);
      globalHome.historyActual ??= history;
    return await ref.set(history.toMap())
        .then((value) => 'Sucesso ao finalizar!')
        .catchError((error) => 'Falha ao salvar!');
  }
  
  Future<String> createSpotHistory({required ParkingSpotModel spot, required String id}) async{
   return await _usersDock.doc(_currentUser!.uid).collection('histories')
        .doc(id)
        .collection('spots')
        .add(spot.toMap())
        .then((value) => 'Sucesso ao finalizar!')
        .catchError((error) => 'Falha ao salvar!');
  }
}
