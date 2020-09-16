
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
  List<RBItem> _itemList = <RBItem>[];
  List<bool> _checkList = <bool>[];
  

  RBPlan({this.name, this.desc});

  int get itemsCount => _itemList.length;

  int get checkedItemsCount{
    int checkedCount = 0;
    print(_checkList);
    _checkList.forEach((element) {
      if(element){
        checkedCount ++;
      }
      });
    return  checkedCount;
  } 

  void addItem(RBItem item){
    _itemList.add(item);
    _checkList.add(false);
  }

  void removeAtIndex(int index){
    _itemList.removeAt(index);
    _checkList.removeAt(index);
  }

  
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'desc': desc,
      'itemList':_itemList.map((e) => {'name':e?.name, 'required':e?.required }).toList(),
      'checkList':_checkList

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
    List<dynamic> checkListJsonObj = jsonObj['checkList'];
    if( checkListJsonObj != null && checkListJsonObj is List){
      this._checkList = checkListJsonObj;
    }
    else{
      this._checkList = itemListJsonObj.map((e) => false).toList();
    }
    return this;
  }


}