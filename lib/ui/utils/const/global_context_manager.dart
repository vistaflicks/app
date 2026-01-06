import 'package:flutter/material.dart';

BuildContext? globalContext;

void setGlobalContext(BuildContext context) {
  globalContext ??= context;
}

BuildContext getContext(){
  return globalContext!;
}