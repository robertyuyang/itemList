import 'dart:async';

import 'package:bloc/bloc.dart';

import 'plan.dart';
import 'package:tuple/tuple.dart';
import 'package:rxdart/rxdart.dart';

class RBPlanState {}

class RBPlanChangedState extends RBPlanState {}

abstract class RBPlanEvent {}

class RBPlanCheckEvent extends RBPlanEvent {
  int index;
  bool checked;
  RBPlanCheckEvent({this.index, this.checked}) {}
}

class RBPlanBloc extends Bloc<RBPlanEvent, RBPlanState> {
  RBPlan _plan = RBPlan();
  StreamSink<bool> savePlanListSink;

  String get name => _plan.name;
  String get desc => _plan.desc;
  double get checkedPercent => itemsCount == 0
      ? 0
      : (checkedItemsCount.toDouble() / itemsCount.toDouble());
  String get checkedPercentString =>
      (checkedPercent * 100).toStringAsFixed(1) + "%";

  RBPlanBloc(this._plan);

  @override
  RBPlanState get initialState => RBPlanState();

  @override
  Stream<RBPlanState> mapEventToState(RBPlanEvent event) async* {
    if (event is RBPlanCheckEvent) {
      yield* this.checkAtIndex(event.index, event.checked);
    }
  }

  int get itemsCount => _plan.itemList.length;

  int get checkedItemsCount {
    int checkedCount = 0;
    _plan.checkList.forEach((element) {
      if (element) {
        checkedCount++;
      }
    });
    return checkedCount;
  }

  

  Tuple2<RBItem, bool> itemAtIndex(int index) => index < _plan.itemList.length
      ? Tuple2(_plan.itemList[index], _plan.checkList[index])
      : null;

  void addItem(RBItem item) {
    _plan.itemList.add(item);
    _plan.checkList.add(false);
    this.savePlanListSink.add(true);
  }

  void removeAtIndex(int index) {
    _plan.itemList.removeAt(index);
    _plan.checkList.removeAt(index);
  }

  Stream<RBPlanState> checkAtIndex(int index, bool checked) async* {
    print('$index $checked');
    if (index < _plan.checkList.length) {
      _plan.checkList[index] = checked;
      this.savePlanListSink.add(true);
      yield RBPlanChangedState();
    }
  }

  Map<String, dynamic> toJson() => _plan.toJson();
}
