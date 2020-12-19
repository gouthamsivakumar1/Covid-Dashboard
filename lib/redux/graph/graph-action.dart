import 'dart:convert';
import 'package:covid_dashboard/const/constants.dart';
import 'package:covid_dashboard/models/countryName.dart';
import 'package:covid_dashboard/models/graphModel.dart';
import 'package:covid_dashboard/redux/country/countryState.dart';
import 'package:covid_dashboard/redux/graph/graphState.dart';
import 'package:covid_dashboard/redux/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';


import 'package:http/http.dart' as http;

@immutable
class SetGraphAction {
  final GraphState postsState;

  SetGraphAction(this.postsState);
}

Future<void> fetchGraphApi(Store<AppState>store,String country,String startDate,String endDate) async {

  try {
    store.dispatch(SetGraphAction(GraphState(graph: [],)));
    store.dispatch(SetGraphAction(GraphState(isLoading: true,)));
    final url = Constants.COUNTY_GRAPH_API.replaceAll('afg?from=2020-11-04T00:00:00Z&to=2020-11-04T00:00:00Z', '$country?from=${startDate}T00:00:00Z&to=${endDate}T00:00:00Z');
    debugPrint("url :$url");
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      debugPrint("json data :${jsonData}");

      store.dispatch(

        SetGraphAction(
          GraphState(
            isLoading: false,
            graph: GraphModel.listFromJson(jsonData),
          ),
        ),
      );
    }
  } on Exception catch (exception) {
    debugPrint("json data :${exception}");
    store.dispatch(SetGraphAction(GraphState(isLoading: false,isError:  true)));
  }
}

