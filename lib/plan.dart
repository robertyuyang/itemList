
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:tuple/tuple.dart';

class RBItem {
  RBItem({this.name, this.required = false});
  String name = 'Default item name';
  bool required = false;
}

class RBCheckItem extends RBItem {

  }
class RBPlan {

  
  String name = 'Default Trip Plan';
  String desc = 'Defualt description';
  //List<Tuple2<RBItem, bool>> _itemTupleList =List<Tuple2<RBItem, bool>>();
  List<RBItem> itemList = <RBItem>[];
  List<bool> checkList = <bool>[];
  

  RBPlan({this.name, this.desc});



  

  
  
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'desc': desc,
      'itemList':itemList.map((e) => {'name':e?.name, 'required':e?.required }).toList(),
      'checkList':checkList

    };
  }
  RBPlan fromJson(Map<String, dynamic> jsonObj){
    if(jsonObj ==null || !(jsonObj is Map)){
      return this;
    }
    this.name = jsonObj['name'];
    this.desc = jsonObj['desc'];
    this.itemList.clear();
    List<dynamic> itemListJsonObj = jsonObj['itemList'];
    if(itemListJsonObj != null && itemListJsonObj is List){
      this.itemList = itemListJsonObj.map((e) => RBItem(name:e['name'], required:e['required'])).toList();
    }
    List<dynamic> checkListJsonObj = jsonObj['checkList'];
    if( checkListJsonObj != null && checkListJsonObj is List){
      this.checkList = checkListJsonObj.cast<bool>();
    }
    else{
      this.checkList = itemListJsonObj.map((e) => false).toList();
    }
    return this;
  }


}