import 'dart:async';
import 'package:blavapp/bloc/app_state/event_focus/event_focus_bloc.dart';
import 'package:blavapp/model/programme.dart';
import 'package:blavapp/services/data_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'programme_event.dart';
part 'programme_state.dart';

class ProgrammeBloc extends Bloc<ProgrammeEvent, ProgrammeState> {
  final DataRepo _dataRepo;
  late final StreamSubscription<EventFocusState> _eventFocusBlocSubscription;
  StreamSubscription<Programme>? _programmeStream;

  ProgrammeBloc({
    required DataRepo dataRepo,
    required EventFocusBloc eventFocusBloc,
  })  : _dataRepo = dataRepo,
        super(
          const ProgrammeState(status: ProgrammeStatus.initial),
        ) {
    _eventFocusBlocSubscription = eventFocusBloc.stream.listen(
        (EventFocusState eventFocusState) =>
            createDataStream(eventTag: eventFocusState.eventTag));
    if (eventFocusBloc.state.status == EventFocusStatus.focused) {
      createDataStream(eventTag: eventFocusBloc.state.eventTag);
    }
    // Event listeners
    on<ProgrammeStreamChanged>(_onProgrammeStreamChanged);
    on<ProgrammeSubscriptionFailed>(_onProgrammeSubscriptionFailed);
  }

  void createDataStream({required String eventTag}) {
    if (_programmeStream != null) {
      _programmeStream!.cancel();
    }
    _programmeStream = _dataRepo
        .getProgrammeStream(eventTag)
        .listen((Programme programme) => add(
              ProgrammeStreamChanged(
                programmeEntries: programme.entries,
              ),
            ))
      ..onError(
        (error) {
          if (error is NullDataException) {
            add(ProgrammeSubscriptionFailed(message: error.message));
          } else {
            add(ProgrammeSubscriptionFailed(message: error.toString()));
          }
        },
      );
  }

  Future<void> _onProgrammeStreamChanged(
      ProgrammeStreamChanged event, emit) async {
    try {
      emit(
        ProgrammeState(
          status: ProgrammeStatus.loaded,
          programmeEntries: event.programmeEntries,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ProgrammeStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onProgrammeSubscriptionFailed(
      ProgrammeSubscriptionFailed event, emit) async {
    emit(
      state.copyWith(
        status: ProgrammeStatus.error,
        message: event.message,
      ),
    );
  }

  @override
  Future<void> close() {
    _programmeStream?.cancel();
    _eventFocusBlocSubscription.cancel();
    return super.close();
  }
}