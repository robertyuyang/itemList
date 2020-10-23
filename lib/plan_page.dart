import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itemlist/plan.dart';
import 'plan_bloc.dart';
import 'item_edit_dialog.dart';

class PlanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlanPageState();
}

class PlanPageState extends State<PlanPage> {
  @override
  void initState() {}

  void addItemCallBack(String name, bool required) {
    //RBPlanBloc planBloc = BlocProvider.of<RBPlanBloc>(context);
    //planBloc.addItem(RBItem(name: name, required: required));
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    final RBPlanBloc planBloc = ModalRoute.of(context).settings.arguments;
    if (!(planBloc is RBPlanBloc)) {
      return Center(child: Text('wrong arguments'));
    }
    return BlocProvider.value(
        value: planBloc,
        child: Scaffold(
            appBar: AppBar(
              title: Text(planBloc.name),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            RBItemEditDialog dialog = RBItemEditDialog();
                            dialog.callback = (String name, bool required) {
                              planBloc.addItem(
                                  RBItem(name: name, required: required));
                            };
                            //dialog.callback = this.addItemCallBack;
                            return dialog;
                          });
                    })
              ],
            ),
            body:
                BlocBuilder<RBPlanBloc, RBPlanState>(builder: (context, state) {
              RBPlanBloc planBloc = BlocProvider.of<RBPlanBloc>(context);
              return Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 160.0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Text(planBloc.desc)),
                        Row(children: <Widget>[
                          Container(
                            width: 100,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              '必备物品',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: 175,
                                height: 30,
                                padding: EdgeInsets.only(
                                    left: 15.0,
                                    top: 10.0,
                                    bottom: 10.0,
                                    right: 10),
                                child: LinearProgressIndicator(
                                    value: planBloc.requiredCheckedPercent,
                                    backgroundColor: Colors.lightGreen.shade100,
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.lightGreen.shade500))),
                          ),
                          //Expanded(child: SizedBox()),
                          Container(
                            width: 90,
                            height: 30,
                            padding: EdgeInsets.only(right: 25),
                            child: Center(
                                child: Text(
                              planBloc.requiredCheckedPercentString,
                              style: (TextStyle(fontSize: 18)),
                            )),
                          )
                        ]),
                        Row(children: <Widget>[
                          Container(
                            width: 100,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              '全部物品',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: 275,
                                height: 30,
                                padding: EdgeInsets.only(
                                    left: 15.0,
                                    top: 10.0,
                                    bottom: 10.0,
                                    right: 10),
                                child: LinearProgressIndicator(
                                  value: planBloc.checkedPercent,
                                  backgroundColor: Colors.lightBlue.shade50,
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.lightBlue.shade200),
                                )),
                          ),
                          Container(
                            height: 30,
                            width: 90,
                            padding: EdgeInsets.only(right: 25),
                            child: Center(
                                child: Text(planBloc.checkedPercentString,
                                    style: TextStyle(fontSize: 12))),
                          )
                        ])
                      ]),
                ),
                Divider(color: Colors.black38),
                Expanded(
                    child: ListView.separated(
                        itemCount:
                            BlocProvider.of<RBPlanBloc>(context).itemsCount,
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.black);
                          if (index == 0) {
                            return Container(
                                child: Container(
                                    alignment: Alignment.bottomRight,
                                    height: 40,
                                    color: Colors.blue.shade300,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'section',
                                      style: TextStyle(color: Colors.white),
                                    )));
                          }
                        },
                        itemBuilder: (context, i) {
                          Tuple2<RBItem, bool> itemMap =
                              BlocProvider.of<RBPlanBloc>(context)
                                  .itemAtIndex(i);
                          int categoryIndex=
                              BlocProvider.of<RBPlanBloc>(context)
                                  .categoryIndexAtItemIndex(i);
                          String categoryName = categoryIndex == -1 ? null : BlocProvider.of<RBPlanBloc>(context).categoryNameAtIndex(categoryIndex);
                          if (itemMap != null && itemMap is Tuple2) {
                            Widget itemRow = Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 30, right: 7),
                                    child: Text(
                                      itemMap.item1.name,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
                                    )),
                                itemMap.item1.required
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(1),
                                            border: Border.all(
                                                color: Colors.blue, width: .5)),
                                        child: Text(
                                          '必备品',
                                          style: TextStyle(fontSize: 10),
                                        ))
                                    : Container(),
                                Expanded(child: SizedBox()),
                                Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Checkbox(
                                        value: itemMap.item2,
                                        onChanged: (checked) {
                                          planBloc.add(RBPlanCheckEvent(
                                              index: i, checked: checked));
                                        }))
                              ],
                            );
                            if (categoryName == null) {
                              return Container(
                                  padding: EdgeInsets.all(5.0), child: itemRow);
                            } else {
                              return Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          height: 40,
                                          color: Colors.indigoAccent.shade100,
                                          alignment: Alignment.topRight,
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: <Widget>[
                                              Text(categoryName,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Expanded(
                                                child: SizedBox(),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        RBItemEditDialog
                                                            dialog =
                                                            RBItemEditDialog(categoryName: '类别： $categoryName',);
                                                        dialog.callback =
                                                            (String name,
                                                                bool required) {
                                                          planBloc.addItem(
                                                              RBItem(
                                                                  name: name,
                                                                  required:
                                                                      required,
                                                                  ),
                                                                  categoryIndex);
                                                        };
                                                        //dialog.callback = this.addItemCallBack;
                                                        return dialog;
                                                      });
                                                },
                                                alignment: Alignment.topCenter,
                                                padding: EdgeInsets.all(0),
                                              )
                                            ],
                                          )),
                                      itemRow
                                    ],
                                  ));
                            }
                          } else {
                            return Text('wrong item!');
                          }
                        }))
              ]);
            })));
  }
}
