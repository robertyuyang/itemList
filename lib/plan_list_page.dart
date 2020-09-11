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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Item List Main Page')),
      body: BlocBuilder<RBPlanListBloc, RBPlanListState>(
          bloc: _planListBloc,
          builder: (context, state) {
            print(state.toString());
            if (state is RBPlanListChangedState) {
              return new ListView.builder(
                  itemCount: _planListBloc.plansCount,
                  itemBuilder: (context, i) {
                    RBPlanBloc planBloc = _planListBloc.planBlocOfIndex(i);
                    return Text(planBloc.name.toString());
                  });
            }
            else if (state is RBPlanListEmptyState){
              return Center(child:Text('no plans!'));
            }
            return Center(child:Text('no plans!'));
          }),
      floatingActionButton: FlatButton.icon(
          onPressed: () {
            _planListBloc.add(RBPlanListAddPlanEvent(name:'UK', desc:'test'));
          },
          icon: Icon(Icons.add_alert),
          label: Text('testadd')),
    );
  }
}
