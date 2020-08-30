import 'package:bloc/bloc.dart';
import 'package:weight_tracker/bloc/nav/nav_event.dart';
import 'package:weight_tracker/bloc/nav/nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc(NavState initialState) : super(initialState);


  @override
  NavState get initialState => ShowNavState(currentIndex: 0);

  @override
  Stream<NavState> mapEventToState(NavEvent event) async* {
    if (event is ChangeNavEvent) {
      yield ShowNavState(currentIndex: event.index, dateTime: event.dateTime);
    }
  }
}
