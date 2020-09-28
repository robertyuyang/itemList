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
  
  void addItemCallBack(String name, bool required){
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
                  icon: Icon(Icons.add), 
                  onPressed: (){
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        RBItemEditDialog dialog =  RBItemEditDialog();
                        dialog.callback = (String name, bool required){
                          planBloc.addItem(RBItem(name: name, required: required));
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
                  height: 70.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                    Text(planBloc.desc),
                    Row(children: <Widget>[
                      Container(
                        width: 275,
                        height: 30,
                        padding: EdgeInsets.only(left:15.0, top:10.0, bottom: 10.0), 
                        child:LinearProgressIndicator(value: planBloc.checkedPercent)),
                      Expanded(child: SizedBox()),
                      Container(
                        height: 30,
                        padding: EdgeInsets.only(right:25),
                        child: Center(child:Text(planBloc.checkedPercentString)),
                        )
                    ])
                  ]),
                ),
                Divider(color: Colors.black38),
                Expanded(
                    child: ListView.separated(
                        itemCount:
                            BlocProvider.of<RBPlanBloc>(context).itemsCount,
                        separatorBuilder: (context, index) =>
                            Divider(color: Colors.black),
                        itemBuilder: (context, i) {
                          Tuple2<RBItem, bool> itemMap =
                              BlocProvider.of<RBPlanBloc>(context)
                                  .itemAtIndex(i);
                          if (itemMap != null && itemMap is Tuple2) {
                            return Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text(
                                        itemMap.item1.name,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 18),
                                      )),
                                  Expanded(child: SizedBox()),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Checkbox(
                                          value: itemMap.item2,
                                          onChanged: (checked) {
                                            planBloc.add(RBPlanCheckEvent(index: i, checked: checked));

                                          }))
                                ],
                              ),
                            );
                          } else {
                            return Text('wrong item!');
                          }
                        }))
              ]);
            })));
  }
}
