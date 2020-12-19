import 'package:covid_dashboard/models/countryName.dart';
import 'package:covid_dashboard/models/graphModel.dart';
import 'package:meta/meta.dart';

@immutable
class CountryState {
  final bool isError;
  final bool isLoading;
  final List<CountryModel> country;

  CountryState({
    this.isError,
    this.isLoading,
    this.country,
  });

  factory CountryState.initial() => CountryState(
    isLoading: false,
    isError: false,
    country: const [],
  );

  CountryState copyWith({
    @required bool isError,
    @required bool isLoading,
    @required List<CountryModel> posts,
  }) {
    return CountryState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      country: posts ?? this.country,
    );
  }
}