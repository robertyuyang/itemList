import 'package:bloc/bloc.dart';

import 'plan.dart';

class RBPlanState {

}
abstract class RBPlanEvent{

}

class RBPlanBloc extends Bloc<RBPlanEvent, RBPlanState>{

  RBPlan _plan = RBPlan();
  
  String get name => _plan.name;
  String get desc => _plan.desc;

  RBPlanBloc(this._plan); 
  @override
  RBPlanState get initialState => RBPlanState();

  @override
  Stream<RBPlanState> mapEventToState(RBPlanEvent event) {
    switch(event){
    }
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() => _plan.toJson();
}