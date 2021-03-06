import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itemlist/plan_bloc.dart';
import 'package:itemlist/plan_page.dart';
import 'plan_list_bloc.dart';
import 'plan_edit_dialog.dart';
import 'plan_copy_dialog.dart';

class ItemListMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItemListMainPageState();
}

class ItemListMainPageState extends State<ItemListMainPage> {
  RBPlanListBloc _planListBloc = RBPlanListBloc();
  @override
  void initState() {
    _planListBloc.add(RBPlanListLoadEvent());
    //WidgetsBinding.instance.addObserver(
    //);
  }

  @override
  void dispose() {
    _planListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('所有计划'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      RBPlanEditDialog dialog = RBPlanEditDialog();
                      dialog.callback = (String name, String desc) {
                        _planListBloc.add(
                            RBPlanListAddPlanEvent(name: name, desc: desc));
                      };
                      //dialog.callback = this.addItemCallBack;
                      return dialog;
                    });
              })
        ],
      ),
      body: BlocBuilder<RBPlanListBloc, RBPlanListState>(
          bloc: _planListBloc,
          builder: (context, state) {
            print(state.toString());
            if (state is RBPlanListChangedState) {
              return new ListView.separated(
                itemCount: _planListBloc.plansCount,
                itemBuilder: (context, i) {
                  RBPlanBloc planBloc = _planListBloc.planBlocOfIndex(i);
                  //planBloc.close();

                  return GestureDetector(
                    child: BlocBuilder<RBPlanBloc, RBPlanState>(
                      bloc: planBloc,
                      builder: (context, state) {
                        return Container(
                            color: Colors.white12,
                            //decoration: BoxDecoration(color: Colors.grey),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/trip.jpg',
                                      width: 100,
                                      height: 70,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(planBloc.name,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 18.0)),
                                            Text(
                                              '${planBloc.itemsCount.toString()} items',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.left,
                                            )
                                          ],
                                        )),
                                    Expanded(child: SizedBox()),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child:
                                          Text(planBloc.checkedPercentString),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 0),
                                        child: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => RBPlanCopySLDialog(this._planListBloc, i)
                                                );
                                          },
                                        ))
                                  ],
                                ),
                              ],
                            ));
                      },
                    ),
                    onTap: () {
                      /*Navigator.push(
                        context, 
                      MaterialPageRoute(builder: (context) {
                        return  BlocProvider(
                          create: (context) => planBloc,
                          child: PlanPage());
                      },));*/
                      Navigator.of(context)
                          .pushNamed('/plan_page', arguments: planBloc);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Colors.grey);
                },
              );
            } else if (state is RBPlanListEmptyState) {
              return Center(child: Text('no plans!'));
            }
            return Center(child: Text('no plans!'));
          }),
      floatingActionButton: FlatButton.icon(
          onPressed: () {
            _planListBloc.add(RBPlanListAddPlanEvent(name: 'UK', desc: 'test'));
          },
          icon: Icon(Icons.add_alert),
          label: Text('testadd')),
    );
  }
}
