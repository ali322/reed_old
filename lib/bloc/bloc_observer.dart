part of bloc;

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent $event');
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition $transition');
  }

  @override
  void onChange(BlocBase base, Change change) {
    super.onChange(base, change);
    // print('onChange -- base: ${base.runtimeType}, change: $change');
  }

  @override
  void onError(BlocBase base, Object error, StackTrace stackTrace) {
    print('onError -- base: ${base.runtimeType}, error: $error');
    super.onError(base, error, stackTrace);
  }

  @override
  void onClose(BlocBase base) {
    super.onClose(base);
    print('onClose -- base: ${base.runtimeType}');
  }
}
