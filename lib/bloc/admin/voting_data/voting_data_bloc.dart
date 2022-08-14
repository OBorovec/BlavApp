import 'dart:async';

import 'package:blavapp/bloc/app/event_focus/event_focus_bloc.dart';
import 'package:blavapp/services/data_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'voting_data_event.dart';
part 'voting_data_state.dart';

class VotingDataBloc extends Bloc<VotingDataEvent, VotingDataState> {
  final DataRepo _dataRepo;
  late final StreamSubscription<EventFocusState> _eventFocusBlocSubscription;
  StreamSubscription<Map<String, dynamic>>? _votingStream;

  VotingDataBloc({
    required DataRepo dataRepo,
    required EventFocusBloc eventFocusBloc,
  })  : _dataRepo = dataRepo,
        super(const VotingDataState()) {
    _eventFocusBlocSubscription = eventFocusBloc.stream.listen(
      (EventFocusState eventFocusState) =>
          createDataStream(eventTag: eventFocusState.eventTag),
    );
    if (eventFocusBloc.state.status == EventFocusStatus.focused) {
      createDataStream(eventTag: eventFocusBloc.state.eventTag);
    }
    // Event listeners
    on<VotingStreamChanged>(_onVotingStreamChanged);
    on<VotingSubscriptionFailed>(_onVotingSubscriptionFailed);
  }

  void createDataStream({required String eventTag}) {
    if (_votingStream != null) {
      _votingStream!.cancel();
    }
    _votingStream = _dataRepo
        .getVotingStream(eventTag)
        .listen((Map<String, dynamic> voting) => add(
              VotingStreamChanged(
                votingData: voting,
              ),
            ))
      ..onError(
        (error) {
          if (error is NullDataException) {
            add(VotingSubscriptionFailed(message: error.message));
          } else {
            add(VotingSubscriptionFailed(message: error.toString()));
          }
        },
      );
  }

  @override
  Future<void> close() {
    _votingStream?.cancel();
    _eventFocusBlocSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onVotingStreamChanged(
    VotingStreamChanged event,
    Emitter<VotingDataState> emit,
  ) {
    try {
      emit(VotingDataState(
        status: DataStatus.loaded,
        data: event.votingData,
      ));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: DataStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onVotingSubscriptionFailed(
    VotingSubscriptionFailed event,
    Emitter<VotingDataState> emit,
  ) {
    state.copyWith(
      status: DataStatus.error,
      message: event.message,
    );
  }
}