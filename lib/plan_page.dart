
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'plan_bloc.dart';



class PlanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlanPageState(); 
}

class PlanPageState extends State<PlanPage> {

  @override
  void initState(){
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(BlocProvider.of<RBPlanBloc>(context).name)),
    );
  }

}