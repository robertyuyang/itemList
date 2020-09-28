import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itemlist/plan.dart';
import 'plan_bloc.dart';

class RBPlanEditDialog extends StatelessWidget {
  RBPlanBloc _planBloc;
  RBPlanEditDialog(RBPlanBloc planBloc) {
    if (planBloc != null) {
      _planBloc = planBloc;
    } else {
      _planBloc = RBPlanBloc(RBPlan(name: '物品名称', desc: '无描述'));
    }
  }
  //@override
  //State<StatefulWidget> createState() => RBPlanEditState();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
            child: BlocBuilder(
      bloc: _planBloc,
      builder: (context, state) => Container(
        height: 250,
        width: 300,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: SizedBox()),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('添加物品')),
                      Expanded(child: SizedBox()),
                    ]),
                Container(
                  alignment: Alignment.centerRight,
                  //padding: EdgeInsets.only(right: 20),
                  child:

                      //Center(child:Text('添加物品')),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                ),
              ],
            ),
            Container(
              child: TextField(),
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Checkbox(value: false, onChanged: (checked) {})),
                Text('必需品')
              ],
            ),
            Container(
              child: RaisedButton(child: Text('添加'), onPressed: () {}),
              padding: EdgeInsets.only(bottom: 15),
            ),
          ],
        ),
      ),
    )));
  }
}
/*
class RBPlanEditState extends State<RBPlanEditDialog>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}*/
