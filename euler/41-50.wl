(* ::Package:: *)

(* ::Title:: *)
(*Project Euler (41\[Dash]50)*)


(* ::Section:: *)
(*41. Pandigital prime*)


Catch @ Do[
  With[{perm = Permutations @ Range @ n},
    Do[If[PrimeQ @ #, Throw[#]] & @ FromDigits @ perm[[-i]], {i, n!}]
  ],
  {n, Range[9, 1, -1]}
]
(* 7652413 *)


(* ::Section:: *)
(*42. Coded triangle numbers*)


With[{data = Import["https://projecteuler.net/project/resources/p042_words.txt", "String"]},
  Count[_?(OddQ @ Sqrt[1 + 8 * Total[ToCharacterCode[#] - 64]] &)] @
    StringSplit[StringDelete[data, "\""], ","]]
(* 162 *)


(* ::Section:: *)
(*43. Sub-string divisibility*)


last3 = Select[IntegerDigits[17 * Range[100]],
  100 < FromDigits[#] < 1000 && DuplicateFreeQ[#] &];
$last4 = Function[digits, Select[Divisible[#, 13] &] @
  (FromDigits[Prepend[Take[digits, 2], #]] & /@ Complement[Range[0, 9], digits])] /@ last3;
last4 = Module[{foo},
  foo[_, {}]    := Nothing;
  foo[a_, {b_}] := Prepend[a, First @ IntegerDigits[b, 10, 3]];
  MapThread[foo, {last3, $last4}]
];
primesDivisible[perm_] := And @@
  MapThread[Divisible, {FromDigits /@ Partition[Take[perm, {2, 8}], 3, 1], Prime @ Range[5]}]
FromDigits /@ Select[primesDivisible] @ Catenate @
  Map[Function[list, Flatten[{#, list}] & /@ Permutations @ Complement[Range[0, 9], list]],
    last4] // Total
(* 16695334890 *)


(* ::Section:: *)
(*44. Pentagon numbers*)


pentagonNumberQ = Compile[{{n, _Integer}},
  ((Round[(1 + Sqrt[24n + 1]) / 6] * 6 - 1)^2 - 1) / 24 == n,
  CompilationTarget -> "C"];
Abs @* Subtract @@ First @
  Select[Apply[pentagonNumberQ[#1 + #2] && pentagonNumberQ[#2 - #1] &]] @
    Subsets[Array[# * (3# - 1) / 2 &, 2200], {2}] // AbsoluteTiming
(* {6.117238, 5482660} *)


(* ::Section:: *)
(*45. Triangular, pentagonal, and hexagonal*)


Intersection @@ Outer[PolygonalNumber, {3, 5, 6}, Range[1*^5]] // Last
(* 1533776805 *)


(* ::Section:: *)
(*46. Goldbach's other conjecture*)


goldbachOddQ[n_] := MemberQ[Sqrt[(n - Prime @ Range @ PrimePi[n]) / 2], _Integer]
NestWhile[# + 2 &, 3, goldbachOddQ, 1] // AbsoluteTiming
(* {6.346, 5777} *)


(* ::Section:: *)
(*47. Distinct primes factors*)


First @ FirstPosition[{4, 4, 4, 4}] @
  Partition[PrimeNu[Range[15*^4]], 4, 1] // AbsoluteTiming
(* {3.85717, 134043} *)


First @ FirstPosition[{4, 4, 4, 4}] @
  Partition[Length /@ FactorInteger[Range[15*^4]], 4, 1] // AbsoluteTiming
(* {0.40695, 134043} *)


(* ::Section:: *)
(*48. Self powers*)


Mod[Sum[i^i, {i, 1000}], 1*^10] // AbsoluteTiming
(* 9110846700 *)


(* ::Section:: *)
(*49. Prime permutations*)


StringJoin @* IntegerString /@ Catenate @
  (Select[Permutations[#, {3}], Apply[Equal] @* Differences] & /@ Select[Length[#] >= 3 &] @
    GatherBy[Prime @ Range[#1 + 1, #2] & @@ PrimePi @ {1000, 10000}, Union @* IntegerDigits])
(* {148748178147, 814748171487, 296962999629, 962962992969} *)


(* ::Section:: *)
(*50. Consecutive prime sum*)


First @ MaximalBy[Last] @ With[{pRange = Prime[Range[600]]},
  Table[Last @ Select[PrimeQ @ Last[#] && Last[#] < 1*^6 &] @
      Map[{i, #, Total @ Take[pRange, {i, UpTo[i + # - 1]}]} &, Range[600]],
    {i, 10}]]
(* {4, 543, 997651} *)
