import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:itemlist/plan.dart';
import 'package:itemlist/plan_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'plan_bloc.dart';

class RBPlanListState {}

class RBPlanListEmptyState implements RBPlanListState {}
class RBPlanListChangedState implements RBPlanListState {}

abstract class RBPlanListEvent {}

class RBPlanListLoadEvent implements RBPlanListEvent {}

class RBPlanListSaveEvent implements RBPlanListEvent {}

class RBPlanListLoadTestEvent implements RBPlanListEvent {}

class RBPlanListAddPlanEvent implements RBPlanListEvent {
  RBPlanListAddPlanEvent({this.name, this.desc});
  String name;
  String desc;
}

class RBPlanListBloc extends Bloc<RBPlanListEvent, RBPlanListState> {
  
  List<RBPlanBloc> planBlocList = <RBPlanBloc>[];
  BehaviorSubject<bool> savePlanListSubject = BehaviorSubject<bool>();

  RBPlanListBloc() {

    this.savePlanListSubject.listen((event) { 
      this.add(RBPlanListSaveEvent());
    });
  }

  Stream<RBPlanListState> _createTestPlanList() async*{
    RBPlanBloc plan1 = RBPlanBloc(RBPlan(name: 'HongKong', desc: 'Trip to HongKong'));
    plan1.addItem(RBItem(name: 'CreditCard', required: true));
    plan1.addItem(RBItem(name: 'Glassess'));
    plan1.addItem(RBItem(name: 'Hat'));
    plan1.addItem(RBItem(name: 'Phone', required: true));
    RBPlanBloc plan2 = RBPlanBloc(RBPlan(name: 'Tailand', desc: 'Trip to Tailand'));
    plan2.addItem(RBItem(name: 'CreditCard'));
    plan2.addItem(RBItem(name: 'Glassess'));
    plan2.addItem(RBItem(name: 'Hat'));

    planBlocList.add(plan1);
    planBlocList.add(plan2);

    yield RBPlanListChangedState();
  }

  @override
  RBPlanListState get initialState => RBPlanListEmptyState();

  @override
  Stream<RBPlanListState> mapEventToState(RBPlanListEvent event) async* {
    if (event is RBPlanListLoadTestEvent) {
      yield* this._createTestPlanList();
    } else if (event is RBPlanListAddPlanEvent) {
      var planBloc = RBPlanBloc(RBPlan(name: event.name, desc: event.desc));
      this.planBlocList.add(planBloc);
      this.add(RBPlanListSaveEvent());
      yield RBPlanListChangedState();
    } else if (event is RBPlanListSaveEvent) {
      _save();
    } else if (event is RBPlanListLoadEvent) {
      yield* _load();
    }
  }

  @override
  void onTransition(Transition<RBPlanListEvent, RBPlanListState> transition) {
    if (transition.nextState is RBPlanListChangedState){
      for(RBPlanBloc bloc in this.planBlocList){
        bloc.savePlanListSink =  savePlanListSubject.sink;
      }
    } 
  }

  int get plansCount => this.planBlocList.length;

  RBPlanBloc planBlocOfIndex(int index) {
    if (index >= planBlocList.length) {
      return null;
    }
    return planBlocList[index];
  }

  Stream<RBPlanListState> _load() async* {
    bool isFirstLaunch = false;
    SharedPreferences sp = await SharedPreferences.getInstance();
    var Launched = sp.getBool('Launched');
    isFirstLaunch = Launched == null;

    if (isFirstLaunch) {
      yield* _createTestPlanList();
      sp.setBool('Launched', true);
    } else {
      yield* _loadFromLocal();

    }
  }

  Stream<RBPlanListState> _loadFromLocal() async*{
    File saveFile = File(await _savePath());
    saveFile.openRead();
    String jsonString =  saveFile.readAsStringSync();
    Map<String, dynamic> jsonObj =  json.decode(jsonString);
    this._fromJson(jsonObj);
    yield RBPlanListChangedState();

  }

  Map<String, dynamic> _toJson() =>
    {'planList':planBlocList.map((e) => e?.toJson()).toList()};

  void _fromJson(Map<String, dynamic> jsonObj){
    if(jsonObj == null){
      return;
    }
    List<dynamic> planListJsons = jsonObj['planList'];
    if(planListJsons is List){
      this.planBlocList.clear();
      planListJsons.forEach((element) {
        this.planBlocList.add(RBPlanBloc(RBPlan().fromJson(element)));
      });
    }
  }

  void _save() async {
    File saveFile = File(await _savePath());
    saveFile.openWrite();
    String jsonString =
        json.encode(_toJson());
    saveFile.writeAsString(jsonString);
  }

  Future<String> _savePath() async {
    String dirString =
        (await getApplicationDocumentsDirectory()).path + '/plans';
    Directory dir = Directory(dirString);
    if (!dir.existsSync()) {
      dir.createSync();
    }
    return dir.path + '/plans.json';
  }
}
