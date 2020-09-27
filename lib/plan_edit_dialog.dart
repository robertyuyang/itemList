import 'package:flutter/material.dart';
import 'plan_bloc.dart';

class RBPlanEditDialog extends StatelessWidget {
  //@override
  //State<StatefulWidget> createState() => RBPlanEditState();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
            child: Container(
      height: 200,
      width: 300,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Container(padding:EdgeInsets.only(top:15), child: Text('添加物品')),
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
            padding: EdgeInsets.all(15),
          ),
          Container(
            child: RaisedButton(child: Text('确定'), onPressed: () {}),
            padding: EdgeInsets.only(bottom: 15),
          ),
        ],
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
