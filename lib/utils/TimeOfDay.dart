
import 'dart:ui' show hashValues;

import 'package:flutter/widgets.dart';
//
//import 'debug.dart';
//import 'material_localizations.dart';


/// Whether the [TimeOfDay] is before or after noon.
enum DayPeriod {
  /// Ante meridiem (before noon).
  am,

  /// Post meridiem (after noon).
  pm,
}

class TimeOfDay {
  /// Creates a time of day.
  ///
  /// The [hour] argument must be between 0 and 23, inclusive. The [minute]
  /// argument must be between 0 and 59, inclusive.
  const TimeOfDay({ this.hour,  this.minute });

  /// Creates a time of day based on the given time.
  ///
  /// The [hour] is set to the time's hour and the [minute] is set to the time's
  /// minute in the timezone of the given [DateTime].
  TimeOfDay.fromDateTime(DateTime time)
      : hour = time.hour,
        minute = time.minute;

  /// Creates a time of day based on the current time.
  ///
  /// The [hour] is set to the current hour and the [minute] is set to the
  /// current minute in the local time zone.
  factory TimeOfDay.now() { return TimeOfDay.fromDateTime(DateTime.now()); }

  /// The number of hours in one day, i.e. 24.
  static const int hoursPerDay = 24;

  /// The number of hours in one day period (see also [DayPeriod]), i.e. 12.
  static const int hoursPerPeriod = 12;

  /// The number of minutes in one hour, i.e. 60.
  static const int minutesPerHour = 60;

  /// Returns a new TimeOfDay with the hour and/or minute replaced.
  TimeOfDay replacing({ int hour, int minute }) {
    assert(hour == null || (hour >= 0 && hour < hoursPerDay));
    assert(minute == null || (minute >= 0 && minute < minutesPerHour));
    return TimeOfDay(hour: hour ?? this.hour, minute: minute ?? this.minute);
  }

  /// The selected hour, in 24 hour time from 0..23.
  final int hour;

  /// The selected minute.
  final int minute;

  /// Whether this time of day is before or after noon.
  DayPeriod get period => hour < hoursPerPeriod ? DayPeriod.am : DayPeriod.pm;

  /// Which hour of the current period (e.g., am or pm) this time is.
  int get hourOfPeriod => hour - periodOffset;

  /// The hour at which the current period starts.
  int get periodOffset => period == DayPeriod.am ? 0 : hoursPerPeriod;

  /// Returns the localized string representation of this time of day.
  ///
  /// This is a shortcut for [MaterialLocalizations.formatTimeOfDay].
//  String format(BuildContext context) {
//    assert(debugCheckHasMediaQuery(context));
//    assert(debugCheckHasMaterialLocalizations(context));
//    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
//    return localizations.formatTimeOfDay(
//      this,
//      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
//    );
//  }

  @override
  bool operator ==(dynamic other) {
    if (other is! TimeOfDay)
      return false;
    final TimeOfDay typedOther = other;
    return typedOther.hour == hour
        && typedOther.minute == minute;
  }

  @override
  int get hashCode => hashValues(hour, minute);

  @override
  String toString() {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10)
        return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(minute);

    return '$TimeOfDay($hourLabel:$minuteLabel)';
  }
}