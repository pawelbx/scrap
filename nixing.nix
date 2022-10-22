with import <nixpkgs> { };
with stdenv.lib;
let
  list = [2 "4" true true {a = 27;} 2];
  f = x: isString x;
  s = "foobar";
in
{
  size = length list;
}