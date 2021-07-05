abstract class CounterStates{}

class CounterInitialState extends CounterStates{}

class CounterPlus extends CounterStates{
  final int counter;
  CounterPlus(this.counter);
}

class CounterMinus extends CounterStates{
  final int counter;
  CounterMinus(this.counter);
}