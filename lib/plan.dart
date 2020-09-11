
import 'package:flutter/material.dart';
import 'dart:convert';

class RBItem {
  RBItem({this.name, this.required = false});
  String name = 'Default item name';
  bool required = false;
}
class RBPlan {
  String name = 'Default Trip Plan';
  String desc = 'Defualt description';
  List<RBItem> _itemList = <RBItem>[];
  RBPlan({this.name, this.desc});

  void addItem(RBItem item){
    _itemList.add(item);
  }
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'desc': desc,
      'itemList':_itemList.map((e) => {'name':e?.name, 'required':e?.required }).toList()
    };
  }
  RBPlan fromJson(Map<String, dynamic> jsonObj){
    if(jsonObj ==null || !(jsonObj is Map)){
      return this;
    }
    this.name = jsonObj['name'];
    this.desc = jsonObj['desc'];
    this._itemList.clear();
    List<dynamic> itemListJsonObj = jsonObj['itemList'];
    if(itemListJsonObj != null && itemListJsonObj is List){
      this._itemList = itemListJsonObj.map((e) => RBItem(name:e['name'], required:e['required'])).toList();
    }
    return this;
  }


}