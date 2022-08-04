import 'package:blavapp/bloc/programme/filter_programme/filter_programme_bloc.dart';
import 'package:blavapp/bloc/app_state/localization/localization_bloc.dart';
import 'package:blavapp/bloc/programme/user_programme_agenda/user_programme_agenda_bloc.dart';
import 'package:blavapp/model/programme.dart';
import 'package:blavapp/utils/model_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ProgrammeAgenda extends StatelessWidget {
  const ProgrammeAgenda({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProgrammeAgendaBloc, UserProgrammeAgendaState>(
      builder: (context, state) {
        final DateTime maxDate = state.event.timestampEnd;
        final DateTime minDate = state.event.timestampStart;
        final Set<int> allDays = List<int>.generate(7, (i) => i).toSet();
        final int dayCount = maxDate.difference(minDate).inDays + 1;
        final Set<int> eventDays = List<int>.generate(
          dayCount,
          (i) => (minDate.weekday + i) % 7,
        ).toSet();
        final List<int> nonEventDays = allDays.difference(eventDays).toList();
        return BlocBuilder<FilterProgrammeBloc, FilterProgrammeState>(
          builder: (context, state) {
            return SfCalendar(
              headerHeight: 0,
              allowedViews: const [
                CalendarView.workWeek,
              ],
              view: CalendarView.workWeek,
              firstDayOfWeek: minDate.weekday,
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 6,
                // endHour: 24,
                nonWorkingDays: nonEventDays,
              ),
              minDate: minDate,
              maxDate: maxDate,
              dataSource: AgendaDataSource(
                state.programmeEntriesFiltered,
                context.watch<LocalizationBloc>().state.appLang,
              ),
            );
          },
        );
      },
    );
  }
}

class AgendaDataSource extends CalendarDataSource {
  List<ProgEntry> programmeEntries;
  final AppLang lang;

  AgendaDataSource(this.programmeEntries, this.lang);

  @override
  List<dynamic> get appointments => programmeEntries;

  @override
  DateTime getStartTime(int index) {
    return programmeEntries[index].timestamp;
  }

  @override
  DateTime getEndTime(int index) {
    return programmeEntries[index]
        .timestamp
        .add(Duration(minutes: programmeEntries[index].duration));
  }

  @override
  String getSubject(int index) {
    Map<String, String> name = programmeEntries[index].name;
    return name[modelAppLang[lang]] ?? name['@en'] ?? 'Undef.';
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}