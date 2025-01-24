import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsInitial()) {
    on<LocationsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
