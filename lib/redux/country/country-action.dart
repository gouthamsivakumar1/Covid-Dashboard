import 'dart:convert';
import 'package:covid_dashboard/const/constants.dart';
import 'package:covid_dashboard/models/countryName.dart';
import 'package:covid_dashboard/models/graphModel.dart';
import 'package:covid_dashboard/redux/country/countryState.dart';
import 'package:covid_dashboard/redux/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';


import 'package:http/http.dart' as http;

@immutable
class SetCountryStateAction {
  final CountryState postsState;

  SetCountryStateAction(this.postsState);
}
Future<void> fetchPostsAction(Store<AppState>store) async {
  store.dispatch(SetCountryStateAction(CountryState(isLoading: true)));

  try {
    final response = await http.get(Constants.COUNTRY_NAME_API);
    assert(response.statusCode == 200);
    final jsonData = json.decode(response.body);
    debugPrint("json data :${jsonData}");
    store.dispatch(

      SetCountryStateAction(
        CountryState(
          isLoading: false,
          country: CountryModel.listFromJson(jsonData),
        ),
      ),
    );
  } on Exception catch (exception) {
    debugPrint("json data :${exception}");
    store.dispatch(SetCountryStateAction(CountryState(isLoading: false)));
  }
}

