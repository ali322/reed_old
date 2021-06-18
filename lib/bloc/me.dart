part of bloc;

abstract class MeEvent extends Equatable {
  const MeEvent();
  @override
  List<Object> get props => [];
}

class FetchMe extends MeEvent {}

abstract class MeState extends Equatable {
  const MeState();

  @override
  List<Object?> get props => [];
}

class MeInitial extends MeState {
  final User? user = null;
  @override
  List<Object?> get props => [user];
}

class MeFetchSuccess extends MeState {
  final User user;
  const MeFetchSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class MeFetchFailure extends MeState {}

class MeBloc extends Bloc<MeEvent, MeState> {
  final UserRepository repository;

  MeBloc({required this.repository})
      : super(MeInitial());

  @override
  Stream<MeState> mapEventToState(MeEvent event) async* {
    if (event is FetchMe) {
      try {
        final _ret = await repository.fetchMe();
        yield MeFetchSuccess(user: _ret);
      } catch (e) {
        yield MeFetchFailure();
      }
    }
  }
}
