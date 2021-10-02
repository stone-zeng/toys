(* ::Package:: *)

(* ::Title:: *)
(*Project Euler (71\[Dash]80)*)


(* ::Section:: *)
(*71. Ordered fractions*)


With[{r = 3/7}, r - Min @ DeleteCases[0] @ Mod[r, 1 / Range[1*^6]]]
(* 428570/999997 *)


(* ::Section:: *)
(*72. Counting fractions*)


Total @ EulerPhi @ Range[2, 1*^6]
(* 303963552391 *)


(* ::Section:: *)
(*73. Counting fractions in a range*)


Count[FareySequence[12000], _?(1/3 < # < 1/2 &)] // AbsoluteTiming
(* {112.195, 7295372} *)


(* ::Section:: *)
(*74. Digit factorial chains*)


Module[{max = 1*^6, len = 60, func, mapFunc, groups, chains},
  func = Total @* Factorial @* IntegerDigits;
  groups = GroupBy[func] @ Range[max];
  chains = Association @ ParallelTable[
    i -> NestWhileList[func, i, UnsameQ @@ {##} &, All, Infinity, -1],
    {i, Keys[groups]}
  ];
  Count[len] @ Flatten[
    Function[{n, chain}, Length[chain] + If[MemberQ[chain, #], 0, 1] & /@ n]
      @@@ Values @ Merge[{groups, chains}, Identity]
  ]
]
(* 402 *)


(* ::Section:: *)
(*75. Singular integer right triangles*)


Module[{max = 15*^5, imax, kmax, triples},
  imax = Ceiling @ Max[i /. Solve[2i * (i + 1) == max, i]];
  triples = Union[Sort /@ Flatten[#, 2] & @
    Table[k * {i^2 - j^2, 2i*j, i^2 + j^2},
      {i, imax}, {j, i - 1}, {k, Floor[max / (2i * (i + j))]}]
  ];
  Count[1] @ KeySort @ Counts @ Select[Total /@ triples, # <= max &]
] // AbsoluteTiming
(* {13.2544, 161667} *)


(* ::Section:: *)
(*76. Counting summations*)


PartitionsP[100] - 1
(* 190569291 *)


(* ::Section:: *)
(*77. Prime summations*)


primePartitions[n_] :=
  Length @ IntegerPartitions[n, All, Prime @ Range @ PrimePi @ n]
NestWhile[# + 1 &, 1, primePartitions[#] < 5000 &]
(* 71 *)


(* ::Section:: *)
(*78. Coin partitions*)


NestWhile[# + 1 &, 1, !Divisible[PartitionsP[#], 1*^6] &]
(* 55374 *)


(* ::Section:: *)
(*79. Passcode derivation*)


keys = EchoFunction[Length] @ IntegerDigits @ Union @ Flatten @
  Import["https://projecteuler.net/project/resources/p079_keylog.txt", "Table"]


isSubset[code_, key_] := Module[{pos},
  pos = Flatten @ Position[code, #] & /@ key;
  AnyTrue[OrderedQ] @ Flatten[Outer[List, Sequence @@ pos], Length[key] - 1]
]


insertSingle[code_, x_] := Join[
  If[MemberQ[code, x], {code}, {}],
  Insert[code, x, #] & /@ Range[Length[code] + 1]
]
insertSingle[x_] := OperatorApplied[insertSingle][x]


insertPart[x_, s_, code_] :=
  Select[isSubset[#, s] &] @ Catenate[insertSingle[x] /@ code];
insertPart[x_, s_] := OperatorApplied[insertPart, 3][x, s]
insert[code_, {i_, j_, k_}] :=
  insertPart[k, {i, j, k}] @ insertPart[j, {i, j}] @ insertSingle[code, i]


FromDigits @ First @ Fold[
  Function[{code, key}, Echo @ MinimalBy[Catenate[insert[#, key] & /@ code], Length]],
  MapAt[List, keys, 1]
]
(* 73162890 *)


(* ::Section:: *)
(*80. Square root digital expansion*)


Total[Total @ First @ RealDigits[#, 10, 100] & /@
  DeleteCases[Sqrt[Range[100]], _Integer]]
(* 40886 *)
