import 'package:covid_dashboard/redux/country/country-action.dart';
import 'package:covid_dashboard/redux/country/countryState.dart';

postsReducer(CountryState prevState, SetCountryStateAction action) {
  final payload = action.postsState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    posts: payload.country,
  );
}