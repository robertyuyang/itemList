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
                  height: 160.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                    Padding(padding:EdgeInsets.only(bottom:30),child: Text(planBloc.desc)),
                    Row(children: <Widget>[
                      Container(width: 100, padding: EdgeInsets.only(left:10),child: Text('必备物品', style: TextStyle(fontSize: 18),),),
                      Expanded(child: 
                      Container(
                        width: 175,
                        height: 30,
                        padding: EdgeInsets.only(left:15.0, top:10.0, bottom: 10.0, right: 10), 
                        child:LinearProgressIndicator(value: planBloc.requiredCheckedPercent,
                        backgroundColor: Colors.lightGreen.shade100 , valueColor: AlwaysStoppedAnimation(Colors.lightGreen.shade500))),
                      ),
                      //Expanded(child: SizedBox()),
                      Container(
                        width: 90,
                        height: 30,
                        padding: EdgeInsets.only(right:25),
                        child: Center(child:Text(planBloc.requiredCheckedPercentString, style: (TextStyle(fontSize:18)),)),
                        )
                    ]),
                    Row(children: <Widget>[
                      Container(width: 100,padding: EdgeInsets.only(left:10),child: Text('全部物品', style: TextStyle(fontSize: 12),),),
                      Expanded(child: 
                      Container(
                        width: 275,
                        height: 30,
                        padding: EdgeInsets.only(left:15.0, top:10.0, bottom: 10.0, right: 10), 
                        child:LinearProgressIndicator(value: planBloc.checkedPercent, 
                        backgroundColor: Colors.lightBlue.shade50 , valueColor: AlwaysStoppedAnimation(Colors.lightBlue.shade200),)),
                      ),
                      Container(
                        height: 30,
                        width: 90,
                        padding: EdgeInsets.only(right:25),
                        child: Center(child:Text(planBloc.checkedPercentString, style: TextStyle(fontSize: 12))),
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
                                      padding: EdgeInsets.only(left: 30,right: 7),
                                      child: Text(
                                        itemMap.item1.name,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 18),
                                      )),
                                  Container(
                                    decoration: BoxDecoration(borderRadius:BorderRadius.circular(1), border: Border.all(color:Colors.blue, width: .5)),
                                    child:Text(itemMap.item1.required ? '必备品':'', style: TextStyle(fontSize: 10),)),
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
