// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryController on HistoryControllerBase, Store {
  Computed<HistoryModel?>? _$historyComputed;

  @override
  HistoryModel? get history =>
      (_$historyComputed ??= Computed<HistoryModel?>(() => super.history,
              name: 'HistoryControllerBase.history'))
          .value;

  late final _$spotsAtom =
      Atom(name: 'HistoryControllerBase.spots', context: context);

  @override
  List<ParkingSpotModel> get spots {
    _$spotsAtom.reportRead();
    return super.spots;
  }

  @override
  set spots(List<ParkingSpotModel> value) {
    _$spotsAtom.reportWrite(value, super.spots, () {
      super.spots = value;
    });
  }

  late final _$getHistoryAsyncAction =
      AsyncAction('HistoryControllerBase.getHistory', context: context);

  @override
  Future<void> getHistory({DateTime? data}) {
    return _$getHistoryAsyncAction.run(() => super.getHistory(data: data));
  }

  late final _$getStopsHistoryAsyncAction =
      AsyncAction('HistoryControllerBase.getStopsHistory', context: context);

  @override
  Future<void> getStopsHistory({required String id}) {
    return _$getStopsHistoryAsyncAction
        .run(() => super.getStopsHistory(id: id));
  }

  @override
  String toString() {
    return '''
spots: ${spots},
history: ${history}
    ''';
  }
}
