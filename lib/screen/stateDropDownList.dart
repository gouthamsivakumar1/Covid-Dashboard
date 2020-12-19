import 'package:covid_dashboard/models/countryName.dart';
import 'package:covid_dashboard/redux/country/countryState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateListDropDown extends StatelessWidget {
  final List<CountryModel> stateList;
  final CountryModel state;
  final Function(CountryModel) onChanged;

  const  StateListDropDown({
    @required this.stateList,
    @required this.state,
    @required this.onChanged,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,

      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CountryModel>(
          value: state,
          items: stateList
              .map((value) => DropdownMenuItem(
            child: Container(
              width: 100,
              child: Text(
                value.country,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,

              ),
            ),
            value: value,
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

