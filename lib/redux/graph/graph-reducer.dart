import 'package:covid_dashboard/redux/country/country-action.dart';
import 'package:covid_dashboard/redux/country/countryState.dart';
import 'package:covid_dashboard/redux/graph/graph-action.dart';
import 'package:covid_dashboard/redux/graph/graphState.dart';

  graphReducer(GraphState prevState, SetGraphAction action) {
  final payload = action.postsState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    graph: payload.graph,
  );
}