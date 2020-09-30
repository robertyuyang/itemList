import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RBPlanEditDialog extends StatefulWidget {
  String name;
  String desc;
  bool required = true;
  Function(String, String) callback = null;
  RBPlanEditDialog({this.name = '计划名称',this.desc = '计划描述'}) {
  }

  @override
  State<StatefulWidget> createState()  => RBPlanEditState();
}

class RBPlanEditState extends State<RBPlanEditDialog> {
  TextEditingController _nameController;
  TextEditingController _descController;
  @override
  void initState(){
    this._nameController = TextEditingController(text: widget.name);
    this._descController = TextEditingController(text: widget.desc);
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      child: Container(
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
                          child: Text('添加计划')),
                      Expanded(child: SizedBox()),
                    ]),
                Container(
                  alignment: Alignment.centerRight,
                  child:
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                ),
              ],
            ),
            Container(
              child: TextField(controller: _nameController),
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            Container(
              child: TextField(controller: _descController),
              padding: EdgeInsets.only(left: 15, right: 15),
            ),
            Container(
              child: RaisedButton(child: Text('添加'), onPressed: () {
                if(widget.callback != null){
                  widget.callback(_nameController.text, _descController.text);
                  Navigator.of(context).pop();
                }
              }),
              padding: EdgeInsets.only(bottom: 15, top:15),
            ),
          ],
        ),
      ),
    ));
  }
}
