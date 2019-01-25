(* ::Package:: *)

Remove["Global`*"]


Needs["Combinatorica`"]


row[length_, maxNum_] :=
  Module[{iter, expr},
    iter = Table[
      {Symbol["i" <> ToString[k]], Symbol["i" <> ToString[k-1]], maxNum},
      {k, length}] /. i0 -> Nothing;
    expr = Table[Symbol["i" <> ToString @ k], {k, length}];
    Flatten[Table @@ Join[{Evaluate @ expr}, Evaluate @ iter], length - 1]]
Echo @ row[3, 5];


tableaux[shape_, maxNum_] :=
  Module[{rows},
    rows = row[#, maxNum]& /@ shape;
    Flatten[Outer[List, Sequence @@ rows, 1], Length[shape] - 1]]
Echo @ tableaux[{2, 1}, 2];


validTableauxQ[p_] := AllTrue[p, OrderedQ[#, Less]&]
Echo[validTableauxQ /@ TransposeTableau /@ tableaux[{2, 1}, 2]];


semistandardTableaux[shape_, maxNum_] :=
  Module[{p},
    p = TransposeTableau /@ tableaux[shape, maxNum];
    TransposeTableau /@ Select[p, validTableauxQ]]
Echo @ Column @ semistandardTableaux[{3, 2, 1}, 3];
