

import 'dart:convert';

import 'package:hash/hash.dart';

int hashPassword(String p){
  int h;
  int add = 0;
  List<int> e = utf8.encode(p);
  for( int u in e){
    add = add + u;
  }
  h = add % 255;
  return h;
}