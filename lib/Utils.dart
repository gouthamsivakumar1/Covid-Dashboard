import 'package:covid_dashboard/screen/homePage.dart';
import 'package:covid_dashboard/widget/datePicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


  showDateTime(BuildContext context,Data date,DateTime selectedFromDate ,DateTime selectedToDate) {
   return showDatePicker(
      context: context,
        initialDate: date == Data.from ? selectedFromDate : selectedToDate,
        // Refer step 1
        firstDate:DateTime(2019),
        lastDate:date == Data.to?DateTime.now():selectedToDate
    );
  }
enum Data {
  to,
  from
}
