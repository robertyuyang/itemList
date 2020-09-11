import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itemlist/plan_bloc.dart';
import 'plan_list_bloc.dart';

class ItemListMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItemListMainPageState();
}

class ItemListMainPageState extends State<ItemListMainPage> {
  RBPlanListBloc _planListBloc = RBPlanListBloc();
  @override
  void initState() {
    _planListBloc.add(RBPlanListLoadEvent());
  }

  @override
  void dispose() {
    _planListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Item List Main Page')),
      body: BlocBuilder<RBPlanListBloc, RBPlanListState>(
          bloc: _planListBloc,
          builder: (context, state) {
            print(state.toString());
            if (state is RBPlanListChangedState) {
              return new ListView.separated(
                  itemCount: _planListBloc.plansCount,
                  itemBuilder: (context, i) {
                    RBPlanBloc planBloc = _planListBloc.planBlocOfIndex(i);
                    planBloc.close();
                    return Container(
                        color: Colors.white12,
                        //decoration: BoxDecoration(color: Colors.grey),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                                  child: Text(planBloc.name,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16.0)),
                                )
                              ],
                            ),
                          ],
                        ));
                  }, separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Colors.grey);
                    },);
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
