import 'package:covid_dashboard/redux/country/country-action.dart';
import 'package:covid_dashboard/redux/country/country-reducer.dart';
import 'package:covid_dashboard/redux/country/countryState.dart';
import 'package:covid_dashboard/redux/graph/graph-action.dart';
import 'package:covid_dashboard/redux/graph/graph-reducer.dart';
import 'package:covid_dashboard/redux/graph/graphState.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetCountryStateAction) {
    final nextPostsState = postsReducer(state.postsState, action);

    return state.copyWith(postsState: nextPostsState);
  }
  if (action is SetGraphAction) {
    final nextPostsState = graphReducer(state.graphState, action);

    return state.copyWith(graphState: nextPostsState);
  }
  return state;
}

@immutable
class AppState {
  final CountryState postsState;
  final GraphState graphState;

  AppState({
    @required this.postsState,
    @required this.graphState,
  });

  AppState copyWith({
    CountryState postsState,
    GraphState graphState,
  }) {
    return AppState(
      postsState: postsState ?? this.postsState,
      graphState: graphState ?? this.graphState,
    );
  }
}

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    final postsStateInitial = CountryState.initial();
    final graphStateInitial = GraphState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(postsState: postsStateInitial,graphState:graphStateInitial ),
    );
  }
}