import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';

class AgeCalc {
  final _dateFormatter = DateFormat('yyyy年MM月dd日');

  DateTime getDatetime(String value) {
    DateTime result = _dateFormatter.parseStrict(value);
    return result;
  }

  String ageCalc(String value) {
    DateTime _birthday = getDatetime(value);
    DateDuration duration = AgeCalculator.age(_birthday);
    final year = duration.years;
    return '$year';
  }
}
