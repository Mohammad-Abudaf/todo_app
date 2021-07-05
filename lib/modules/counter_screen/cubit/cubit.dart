import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modules/counter_screen/cubit/states.dart';

class CounterCubit extends Cubit<CounterStates>{
  CounterCubit() : super (CounterInitialState());
  int counter = 1;
  static CounterCubit get(context) => BlocProvider.of(context);
  void minus(){
    counter--;
    emit(CounterMinus(counter));
  }
  void plus(){
    counter++;
    emit(CounterPlus(counter));
  }
}