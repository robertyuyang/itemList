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


class RBPlanChangedEvent extends RBPlanEvent{}
class RBPlanAddCategoryEvent extends RBPlanEvent{
  String name;
  RBPlanAddCategoryEvent(this.name);
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
  
  double get requiredCheckedPercent {
    double requiredCheckedItemsCount = 0.0;
    double requiredItemsCount = 0.0;
    int itemCount = this._plan.itemList.length;
    for(int i  = 0; i < itemCount; i++){
      if(_plan.itemList[i].required){
        requiredItemsCount++;
        if(_plan.checkList[i]){
          requiredCheckedItemsCount++;
        }
      }
    }
    
    return requiredItemsCount == 0 ? 0 :  requiredCheckedItemsCount / requiredItemsCount; 
  }

  String get requiredCheckedPercentString => (requiredCheckedPercent * 100).toStringAsFixed(1) + '%';

  RBPlanBloc(this._plan);


  @override
  RBPlanState get initialState => RBPlanState();

  @override
  Stream<RBPlanState> mapEventToState(RBPlanEvent event) async* {
    if (event is RBPlanCheckEvent) {
      yield* this.checkAtIndex(event.index, event.checked);
    }
    else if (event is RBPlanChangedEvent){
      yield RBPlanChangedState();
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
  
  String categoryNameAtIndex(int categoryIndex){
    if (categoryIndex  != -1) {
      return _plan.categoryNameList[categoryIndex];
    }
    return null;
  }

  int categoryIndexAtItemIndex(int index) => _plan.categoryStartList.indexOf(index);

  RBPlan get currentPlan => this._plan; 
  void addItem(RBItem item, [int categoryIndex = 0]) {
    if(categoryIndex >= _plan.categoryNameList.length){
      return;
    }

    int categoryStart = _plan.categoryStartList[categoryIndex];
    _plan.itemList.insert(categoryStart, item);
    _plan.checkList.insert(categoryStart, false);
    _plan.categoryItemCountList[categoryIndex]++;
    if(this.savePlanListSink != null){
      this.savePlanListSink.add(true);
    }
    this.add(RBPlanChangedEvent());
  }

  void addCategory(String name){
    _plan.categoryNameList.insert(0, name);
    _plan.categoryItemCountList.insert(0, 0);
    this.add(RBPlanChangedEvent());
  }

  void removeAtIndex(int index) {
    _plan.itemList.removeAt(index);
    _plan.checkList.removeAt(index);
    if(this.savePlanListSink != null){
      this.savePlanListSink.add(true);
    }
    this.add(RBPlanChangedEvent());
  }

  Stream<RBPlanState> checkAtIndex(int index, bool checked) async* {
    print('$index $checked');
    if (index < _plan.checkList.length) {
      _plan.checkList[index] = checked;
      if(this.savePlanListSink != null){
        this.savePlanListSink.add(true);
      }
      yield RBPlanChangedState();
    }
  }

  Map<String, dynamic> toJson() => _plan.toJson();
}
