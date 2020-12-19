import 'package:covid_dashboard/models/countryName.dart';
import 'package:covid_dashboard/models/graphModel.dart';
import 'package:meta/meta.dart';

@immutable
class GraphState {
  final bool isError;
  final bool isLoading;
  final List<GraphModel> graph;

  GraphState({
    this.isError,
    this.isLoading,
    this.graph,
  });

  factory GraphState.initial() => GraphState(
    isLoading: false,
    isError: false,
    graph: const [],
  );

  GraphState copyWith({
    @required bool isError,
    @required bool isLoading,
    @required  List<GraphModel> graph,
  }) {
    return GraphState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      graph: graph ?? this.graph,
    );
  }
}