// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on HomeControllerBase, Store {
  Computed<double>? _$priceToPayComputed;

  @override
  double get priceToPay =>
      (_$priceToPayComputed ??= Computed<double>(() => super.priceToPay,
              name: 'HomeControllerBase.priceToPay'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: 'HomeControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$userDataAtom =
      Atom(name: 'HomeControllerBase.userData', context: context);

  @override
  UserModel? get userData {
    _$userDataAtom.reportRead();
    return super.userData;
  }

  @override
  set userData(UserModel? value) {
    _$userDataAtom.reportWrite(value, super.userData, () {
      super.userData = value;
    });
  }

  late final _$spotActualAtom =
      Atom(name: 'HomeControllerBase.spotActual', context: context);

  @override
  ParkingSpotModel? get spotActual {
    _$spotActualAtom.reportRead();
    return super.spotActual;
  }

  @override
  set spotActual(ParkingSpotModel? value) {
    _$spotActualAtom.reportWrite(value, super.spotActual, () {
      super.spotActual = value;
    });
  }

  late final _$historyActualAtom =
      Atom(name: 'HomeControllerBase.historyActual', context: context);

  @override
  HistoryModel? get historyActual {
    _$historyActualAtom.reportRead();
    return super.historyActual;
  }

  @override
  set historyActual(HistoryModel? value) {
    _$historyActualAtom.reportWrite(value, super.historyActual, () {
      super.historyActual = value;
    });
  }

  late final _$getUserDataStreamAsyncAction =
      AsyncAction('HomeControllerBase.getUserDataStream', context: context);

  @override
  Future<Stream<QuerySnapshot<Object?>>> getUserDataStream(
      {bool? filterName, bool? available, String? termo}) {
    return _$getUserDataStreamAsyncAction.run(() => super.getUserDataStream(
        filterName: filterName, available: available, termo: termo));
  }

  late final _$HomeControllerBaseActionController =
      ActionController(name: 'HomeControllerBase', context: context);

  @override
  void updateData(
      {required Map<String, dynamic> data,
      bool isSpot = false,
      bool isBigData = false}) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.updateData');
    try {
      return super.updateData(data: data, isSpot: isSpot, isBigData: isBigData);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveHistory() {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.saveHistory');
    try {
      return super.saveHistory();
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
userData: ${userData},
spotActual: ${spotActual},
historyActual: ${historyActual},
priceToPay: ${priceToPay}
    ''';
  }
}
