extension RoundUp on double {
  int get roundUpAbs => isNegative ? floor() : ceil();
}
