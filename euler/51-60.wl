(* ::Package:: *)

(* ::Title:: *)
(*Project Euler (51\[Dash]60)*)


(* ::Section:: *)
(*51. Prime digit replacements*)


length = 8;
getPatterns[n_] := {ReplacePart[Table[_, n], Thread[# -> x_]], Complement[Range[n], #]} & /@
  Subsets[Range[n - 1], {1, n - 1}]
getDigits[n_] := IntegerDigits @ Prime @ Range[PrimePi[10^(n - 1)] + 1, PrimePi[10^n]]
FromDigits /@ Catch @ Do[
  With[{digits = getDigits[n]}, Do[
    With[{pattern = First @ p, pos = Last @ p},
      If[Length[#] == length, Throw[#]] & /@
        GatherBy[Cases[digits, pattern], #[[pos]] &]],
    {p, getPatterns[n]}]],
  {n, 2, 8}]
(* {121313, 222323, 323333, 424343, 525353, 626363, 828383, 929393} *)


(* ::Section:: *)
(*52. Permuted multiples*)


Catch @ Do[If[Equal @@ Sort /@ IntegerDigits[j * {2, 3, 4, 5, 6}], Throw[j]],
  {i, PowerRange[1*^5]}, {j, i, 5i / 3}]
(* 142857 *)


(* ::Section:: *)
(*53. Combinatoric selections*)


Count[Flatten @ Table[Binomial[i, j], {i, 100}, {j, i}], _?(# > 1*^6 &)]
(* 4075 *)


(* ::Section:: *)
(*54. Poker hands*)


pokerValue[list_] := Flatten[$pokerValue @@ Sort[list /. rules]]
rules = Join @@ Thread /@
  {CharacterRange["2", "9"] -> Range[2, 9], {"T", "J", "Q", "K", "A"} -> Range[10, 14]}
(* Royal Flush *)
$pokerValue[{10, s_}, {11, s_}, {12, s_}, {13, s_}, {14, s_}] :=
  {9}
(* Straight Flush *)
$pokerValue[{a_, s_}, {b_, s_}, {c_, s_}, {d_, s_}, {e_, s_}] :=
  {8, {e, d, c, b, a}} /; {a, b, c, d, e} == a + Range[0, 4]
(* Four of a Kind *)
$pokerValue[{a_, _}, {b_, _}, {c_, _}, {d_, _}, {e_, _}] :=
  {7, Keys @ ReverseSort @ Counts[{a, b, c, d, e}]} /;
    Values @ Sort @ Counts[{a, b, c, d, e}] == {1, 4}
(* Full House *)
$pokerValue[{a_, _}, {b_, _}, {c_, _}, {d_, _}, {e_, _}] :=
  {6, Keys @ ReverseSort @ Counts[{a, b, c, d, e}]} /;
    Values @ Sort @ Counts[{a, b, c, d, e}] == {2, 3}
(* Flush *)
$pokerValue[{a_, s_}, {b_, s_}, {c_, s_}, {d_, s_}, {e_, s_}] :=
  {5, {e, d, c, b, a}}
(* Straight *)
$pokerValue[{a_, _}, {b_, _}, {c_, _}, {d_, _}, {e_, _}] :=
  {4, {e, d, c, b, a}} /; {a, b, c, d, e} == a + Range[0, 4]
$pokerValue[{a_, _}, {b_, _}, {c_, _}, {d_, _}, {e_, _}] := With[
  {counts = ReverseSort @ Counts[{a, b, c, d, e}]},
  Switch[Values[counts],
    (* Three of a Kind *)
    {3, 1, 1},       {3, First[#], ReverseSort @ Rest[#]},
    (* Two Pairs *)
    {2, 2, 1},       {2, ReverseSort @ Most[#], Last[#]},
    (* One Pair *)
    {2, 1, 1, 1},    {1, First[#], ReverseSort @ Rest[#]},
    (* High Card *)
    {1, 1, 1, 1, 1}, {0, {e, d, c, b, a}}
  ] & @ Keys[counts]
]


playerOneWinQ[list1_, list2_] := FirstCase[
  Subtract @@ PadRight[pokerValue /@ {list1, list2}], Except[0]] > 0


data = Partition[Characters /@ #, 5] & /@
  Import["https://projecteuler.net/project/resources/p054_poker.txt", "Table"];
Count[playerOneWinQ @@@ data, True]
(* 376 *)


(* ::Section:: *)
(*55. Lychrel numbers*)


With[{f = # + IntegerReverse[#] &},
  Length @ Select[GreaterThan[50]] @
    Table[Length @ NestWhileList[f, f[n], Not @* PalindromeQ, 1, 50], {n, 10000}]]
(* 249 *)


(* ::Section:: *)
(*56. Powerful digit sum*)


Max[Total /@ IntegerDigits @ Flatten @ Array[Power, {100, 100}]]
(* 972 *)


(* ::Section:: *)
(*57. Square root convergents*)


With[{n = 1000 + 1}, Length @ DeleteCases[{x_, x_}] @ Map[
  IntegerLength @* NumeratorDenominator,
  FromContinuedFraction[Take[ContinuedFraction[Sqrt[2], n], #]] & /@ Range[2, n]]]
(* 153 *)


(* ::Section:: *)
(*58. Spiral primes*)


First @ NestWhile[
  Apply[{#1 + 2, #2 + Count[(#1 + 2)^2 - {0,1,2,3} * (#1 + 1), _?PrimeQ]} &],
  {3, 3},
  Apply[#2 / (2#1 - 1) > 0.1 &]]
(* 26241 *)


(* ::Section:: *)
(*59. XOR decryption*)


data = First @ Import["https://projecteuler.net/project/resources/p059_cipher.txt", "CSV"];
tuples = Tuples[Flatten @ ToCharacterCode @ CharacterRange["a", "z"], 3];
xorSequence[ker_, list_] := MapThread[BitXor, {PadRight[ker, Length[list], ker], list}]
AbsoluteTiming[text = With[{list = data[[;;20]]},
  Association @ Table[
    FromCharacterCode[k] -> TextWords @ FromCharacterCode @ xorSequence[k, list], {k, tuples}]];]
(* {61.324286, Null} *)

Select[text, AllTrue[DictionaryWordQ]]
(* <|"exp" -> {"An", "extract", "taken", "fro"}|> *)

Total @ xorSequence[ToCharacterCode["exp"], data]
(* 129448 *)


FromCharacterCode @ xorSequence[ToCharacterCode["exp"], data]
(*
An extract taken from the introduction of one of Euler's most celebrated papers, "De summis
serierum reciprocarum" [On the sums of series of reciprocals]: I have recently found, quite
unexpectedly, an elegant expression for the entire sum of this series 1 + 1/4 + 1/9 + 1/16 +
etc., which depends on the quadrature of the circle, so that if the true sum of this series is
obtained, from it at once the quadrature of the circle follows. Namely, I have found that the sum
of this series is a sixth part of the square of the perimeter of the circle whose diameter is 1;
or by putting the sum of this series equal to s, it has the ratio sqrt(6) multiplied by s to 1 of
the perimeter to the diameter. I will soon show that the sum of this series to be approximately
1.644934066842264364; and from multiplying this number by six, and then taking the square root, the
number 3.141592653589793238 is indeed produced, which expresses the perimeter of a circle whose
diameter is 1. Following again the same steps by which I had arrived at this sum, I have
discovered that the sum of the series 1 + 1/16 + 1/81 + 1/256 + 1/625 + etc. also depends on the
quadrature of the circle. Namely, the sum of this multiplied by 90 gives the biquadrate (fourth
power) of the circumference of the perimeter of a circle whose diameter is 1. And by similar
reasoning I have likewise been able to determine the sums of the subsequent series in which the
exponents are even numbers.
*)


(* ::Section:: *)
(*60. Prime pair sets*)


pairPrimesQ[list_] := AllTrue[Permutations[list, {2}], $pairPrimesQ]
$pairPrimesQ[{a_, b_}] := PrimeQ[a * 10^IntegerLength[b] + b]

Print["time(x1) = ", First  @ AbsoluteTiming[x1 = Prime @ Range[2, PrimePi @ 1000]]]
Print["len(x1)  = ", Length @ x1]
Print["time(x2) = ", First  @ AbsoluteTiming[x2 = Select[Subsets[x1, {2}], pairPrimesQ]]]
Print["len(x2)  = ", Length @ x2];
Print["time(x3) = ", First  @ AbsoluteTiming[x3 = Union[Union @@@ Subsets[x2, {2}]]]]
Print["len(x3)  = ", Length @ x3];
Print["time(x4) = ", First  @ AbsoluteTiming[x4 = Select[x3, Length[#] == 3 && pairPrimesQ[#] &]]]
Print["len(x4)  = ", Length @ x4];
Print["time(x5) = ", First  @ AbsoluteTiming[x5 = Union[Union @@@ Subsets[x4, {2}]]]]
Print["len(x5)  = ", Length @ x5];
Print["time(x6) = ", First  @ AbsoluteTiming[x6 = Select[x5, Length[#] == 4 && pairPrimesQ[#] &]]]
Print["len(x6)  = ", Length @ x6];
Print["time(x7) = ", First  @ AbsoluteTiming[x7 = Union[Union @@@ Subsets[x6, {2}]]]]
Print["len(x7)  = ", Length @ x7];

Print["x8 = ", x8 = Select[x7, Length[#] == 5 && pairPrimesQ[#] &];];
Total @ First[x8]

(*
time(x1) = 0.000826
len(x1)  = 1228
time(x2) = 3.457
len(x2)  = 18176
time(x3) = 224.041
len(x3)  = 164916830
time(x4) = 142.298
len(x4)  = 9904
time(x5) = 76.4542
len(x5)  = 49030466
time(x6) = 41.6975
len(x6)  = 294
time(x7) = 0.0596
len(x7)  = 43057
x8 = {{13, 5197, 5701, 6733, 8389}}
*)

(* 26033 *)
