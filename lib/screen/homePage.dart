import 'package:charts_flutter/flutter.dart';
import 'package:covid_dashboard/Utils.dart';
import 'package:covid_dashboard/config/palette.dart';
import 'package:covid_dashboard/const/constants.dart';
import 'package:covid_dashboard/models/task.dart';
import 'package:covid_dashboard/models/countryName.dart';
import 'package:covid_dashboard/models/graphModel.dart';
import 'package:covid_dashboard/redux/country/country-action.dart';
import 'package:covid_dashboard/redux/graph/graph-action.dart';
import 'package:covid_dashboard/redux/store.dart';
import 'package:covid_dashboard/screen/stateDropDownList.dart';
import 'package:covid_dashboard/styles/styles.dart';
import 'package:covid_dashboard/widget/datePicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'customAppBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<charts.Series<Task, String>> _seriesData = List<
      charts.Series<Task, String>>();
  final _myState = new charts.UserManagedState<String>();
  int totalDeath = 0;
  int totalActive = 0;
  int totalConfirmed = 0;
  int totalCases = 0;
  CountryModel selectedState;
  DateTime selectedToDate = DateTime.now();
  DateTime selectedFromDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Flexible(
              child: StoreConnector<AppState, List<CountryModel>>(
                  distinct: true,
                  converter: (store) => store.state.postsState.country,
                  builder: (context, posts) {
                    return (posts.isNotEmpty) ? _buildHeader(
                        screenHeight, posts) : SizedBox(height: 50,);
                  })),
          StoreConnector<AppState, bool>(
            distinct: true,
            converter: (store) => store.state.postsState.isLoading,
            builder: (context, isLoading) {
              if (isLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          StoreConnector<AppState, bool>(
            distinct: true,
            converter: (store) => store.state.postsState.isError,
            builder: (context, isError) {
              if (isError) {
                return Text("Failed to get posts");
              } else {
                return SizedBox.shrink();
              }
            },
          ),


        ],
      ),

    );

  }
  getTotalCount(List<GraphModel> posts) async {
    {
      _seriesData.clear();
      totalActive = 0;
      totalCases = 0;
      totalConfirmed = 0;
      totalDeath = 0;
      for (var data in posts) {
        totalCases += data.active + data.confirmed + data.deaths;
        totalActive += data.active;
        totalConfirmed += data.confirmed;
        totalDeath += data.deaths;
      }
      var cases = totalCases;
      var active =  ((totalActive / totalCases) * 100);
      var confirmed =   ((totalConfirmed / totalCases) * 100);
      var death =   ((totalDeath / totalCases) * 100);

      debugPrint("caases :${active}");
      var pieData = [
        new Task("Active", active, Colors.blue),
        new Task("Confirmed", confirmed, Colors.red),
        new Task("Death", death, Colors.green)
      ];

      _seriesData.add(charts.Series(data: pieData,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Covid Status',
        labelAccessorFn: (Task row, _) => '${row.taskvalue.roundToDouble()}%',

      ));
    }

  }
  Widget _buildHeader(double screenHeight, List<CountryModel> country) {
    return Column(
      children: [
        Container(padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Palette.primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40))
          ), child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(Constants.COVID, style: Styles.btn25TextStyle,),
                  Container(width: 100,),
                  Expanded(
                    child: StateListDropDown(stateList: country,
                      state: selectedState == null
                          ? country[0]
                          : selectedState,
                      onChanged: (val) =>
                          setState(() {
                            debugPrint("stateName :$val");
                            selectedState = val;
                            _onFetchGraphData(val.countryInfo.iso2);
                          }),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From Date :", style: Styles.btn20TextStyle,),
                      SizedBox(height: 10,),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black)
                        ),
                        color: Colors.white,
                        child: datePicker(selectedFromDate),
                        onPressed: () => _selectDate(context, Data.from),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To Date :", style: Styles.btn20TextStyle,),
                      SizedBox(height: 10,),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black)
                          ),
                          color: Colors.white,
                          child: datePicker(selectedToDate),
                          onPressed: () => _selectDate(context, Data.to)

                      ),

                    ],
                  ),
                ],
              )


            ],),),

        StoreConnector<AppState, bool>(
          distinct: true,
          converter: (store) => store.state.graphState.isError,
          builder: (context, isError) {
            if (isError) {
              return Text("Failed to get graph");
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        StoreConnector<AppState, bool>(
          distinct: true,
          converter: (store) => store.state.graphState.isLoading,
          builder: (context, isLoading) {
            if (isLoading) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        StoreConnector<AppState, List<GraphModel>>(
            distinct: true,
            converter: (store) => store.state.graphState.graph,
            builder: (context, posts) {

              debugPrint("posr :${posts.toList()}");
             if(posts.isNotEmpty ){
               getTotalCount(posts);
               return Expanded(
                 child: Container(
                  width: double.infinity,
                  child: charts.PieChart(
                    _seriesData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification: charts.OutsideJustification
                            .endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 11),
                      )
                    ],

                    selectionModels: [
                      new charts.SelectionModelConfig(
                  changedListener: (SelectionModel model) {
                 if(model.hasDatumSelection) {
                   var message = "${model.selectedSeries[0].domainFn(
                       model.selectedDatum[0].index)} :${model.selectedSeries[0].measureFn(
                       model.selectedDatum[0].index).roundToDouble()}%" ;
                   scaffoldKey.currentState.showSnackBar(
                       SnackBar(content: Text(message.toString())));
                 }
                 })
                    ],
                      defaultRenderer: new charts.ArcRendererConfig(

                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                              showLeaderLines: true,
                                labelPosition: charts.ArcLabelPosition.inside)
                          ]),
                  )),
               );
                 }
             else {
               return SizedBox.shrink();
             }

            }),

      ],
    );
  }

  _selectDate(BuildContext context, Data date) async {
    final DateTime picked =await showDateTime(context,date,selectedFromDate,selectedToDate);
    switch (date) {
      case Data.from:
        if (picked != null && picked != selectedFromDate) {
          setState(() {
            if(picked.isAfter( selectedToDate))
              {
                selectedToDate =picked;
                selectedFromDate = picked;
              }
            else
              {
                selectedFromDate = picked;
              }
            _onFetchGraphData(selectedState.countryInfo.iso2);

          });
        }
        break;
      case Data.to:
        if (picked != null && picked != selectedToDate) {
          setState(() {
            if(picked.isBefore( selectedFromDate))
            {
              selectedToDate =picked;
              selectedFromDate = picked;
            }
            else {
              selectedToDate = picked;
            }
            _onFetchGraphData(selectedState.countryInfo.iso2);
          });
        }
        break;
    }
  }

  @override
  void initState() {
    _onFetchPostsPressed();
  }
  Future<void> _onFetchPostsPressed() async {
    await Redux.store.dispatch(fetchPostsAction);
    _onFetchGraphData("afg");
  }
  Future<void> _onFetchGraphData(String country) async {
    await Redux.store.dispatch(fetchGraphApi(Redux.store,country,'${selectedFromDate.toLocal()}'.split(' ')[0],'${selectedToDate.toLocal()}'.split(' ')[0]));
  }

}

