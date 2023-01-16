import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionei/components/base_box_widget.dart';
import 'package:estacionei/components/text_field_widget.dart';
import 'package:estacionei/global.dart';
import 'package:estacionei/models/parking_spot_model.dart';
import 'package:estacionei/utils/colors_util.dart';
import 'package:estacionei/utils/dialog_util.dart';
import 'package:estacionei/utils/double_extension.dart';
import 'package:estacionei/utils/firebase_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import '../components/app_bar_widget.dart';
import '../components/select_box_widget.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAvailable = false;
  bool isOccupied = false;
  late double widthScreen;
  final _controllerFilterPlate = TextEditingController();
  final _controllerFilterSpot = TextEditingController();
  var _controllerSpot = TextEditingController();
  final _usersStream = StreamController<QuerySnapshot>.broadcast();
  double valueToPay = 0.0;

  _verifyLogin(VoidCallback finish) {
    final _userService = UserService();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async{
      if (user == null) {
        print('User is currently signed out!');
        await FirebaseUtil.signInWithGoogle();
      }
      if(!await _userService.userExist()){
        await _userService.registerUser();
      }else{
        globalHome.userData = await _userService.getUserData();
      }

      globalHome.isLoading = false;
      print('User is signed in!');
      finish();
    });
  }
  _cleanControllers(){
    _controllerFilterSpot.clear();
    _controllerFilterPlate.clear();
  }

  _listnerController({bool? filterName, bool? available, String? termo}){
    globalHome.getUserDataStream(filterName: filterName, available: available, termo:  termo).then((value) => value.listen((event) {
      _usersStream.add(event);
    }));
  }

  @override
  void initState(){
    _verifyLogin(()=> _listnerController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    var sizeStatusBar = MediaQuery.of(context).padding.top + 8;

    return Observer(builder: (_) {
      if (globalHome.isLoading) {
        return const Center(
          child: SizedBox(
            height: 50,
              width: 50,
              child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: EdgeInsets.only(top: sizeStatusBar),
              child: AppBarWidget(),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectsWidget(),
              _filtersWidget(),
              _builderParkingSpotsWidget()
            ],
          ),
        ),
      );
    });
  }

  _selectsWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelectBoxWidget(
                height: 46,
                width: widthScreen * .45,
                color: ColorsUtil.verde,
                text: 'DISPONÍVEL',
                selected: isAvailable,
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                    isOccupied = false;
                    _cleanControllers();
                  });
                  _listnerController(available: isAvailable ? true : null);
                }),
            SelectBoxWidget(
                height: 46,
                width: widthScreen * .45,
                color: ColorsUtil.laranja,
                text: 'OCUPADO',
                selected: isOccupied,
                onChanged: (value) {
                  setState(() {
                    isOccupied = value;
                    isAvailable = false;
                    _cleanControllers();
                  });
                  _listnerController(available: isOccupied ? false : null);
                })
          ],
        ),
      );
  }

  _filtersWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFieldWidget(
              width: widthScreen * .45,
              hintText: 'Informe a placa',
              controller: _controllerFilterPlate,
              textCapitalization: TextCapitalization.characters,
              inputFormatter: [PlacaVeiculoInputFormatter()],
              onSubmitted: (value) {
                _controllerFilterSpot.clear();
                _listnerController(termo: value, filterName: false);
              },
            ),
            TextFieldWidget(
              width: widthScreen * .45,
              hintText: 'Informe a vaga',
              controller: _controllerFilterSpot,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (value) {
                _controllerFilterPlate.clear();
                _listnerController(termo: value, filterName: true);
              },
            )
          ],
        ));
  }

  _builderParkingSpotsWidget() {
    return StreamBuilder(
      stream: _usersStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
              alignment: Alignment.center,
              height: widthScreen,
              child: const Text('Tivemos algum problema...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox(
            height: 50,
              width: 50,
              child: CircularProgressIndicator()));
        }
        var data = snapshot.data!.docs.toList();
         var spots = List<ParkingSpotModel>.from(data.map((spot) => ParkingSpotModel.fromMap(spot.data() as Map<String, dynamic>)));
         globalHome.userData!.spots = spots;
          if (spots.isEmpty) {
            return Container(
                alignment: Alignment.center,
                height: widthScreen,
                child: const Text('Não foi encontrada nenhuma Vaga',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));
          }
          return Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16),
                itemCount: spots.length,
                itemBuilder: (context, index) {
                  var spot = spots[index];
                  return GestureDetector(
                    onTap: () {
                      _controllerSpot = TextEditingController();
                      DialogUtil.showAlertSimNao(
                          context: context,
                          content: _dialogContent(spot),
                          title: 'Vaga ${spot.name}',
                          confirm: spot.available ? 'RESERVAR' : 'FINALIZAR',
                          simListener: () {
                            if (spot.available) {
                              if (_controllerSpot.text.isNotEmpty &&
                                  _controllerSpot.text.length == 8) {
                                spot.inputVehicleInSpot(_controllerSpot.text);
                                globalHome.updateData(data: spot.toMap(), isSpot: true);
                              }
                              return;
                            }
                            spot.exitTime = DateTime.now();
                            spot.available = true;
                            globalHome.spotActual = spot;
                            globalHome.saveHistory();
                          });
                    },
                    child: BaseBoxWidget(
                      color: spot.available ? ColorsUtil.verde : ColorsUtil.laranja,
                      child: Text(spot.name,
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(.60))),
                    ),
                  );
                }),
          );
        });
  }

  _dialogContent(ParkingSpotModel spot) {
    if (spot.available) {
      return TextFieldWidget(
          width: 150,
          hintText: 'Informe a placa do veículo',
          textCapitalization: TextCapitalization.characters,
          inputFormatter: [PlacaVeiculoInputFormatter()],
          controller: _controllerSpot);
    }
    globalHome.spotActual = spot;
    spot.price = globalHome.priceToPay;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(spot.plate!,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            Text('R\$${spot.price!.convertToReal()}',
                textAlign: TextAlign.end,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400))
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Entrada ${DateFormat.Hm().format(spot.entryTime!)}',
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            Text('Saida* ${DateFormat.Hm().format(DateTime.now())}',
                textAlign: TextAlign.end,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400))
          ],
        )
      ],
    );
  }
}
