(* ::Package:: *)

(* ::Title:: *)
(*Project Euler (31\[Dash]40)*)


(* ::Section:: *)
(*31. Coin sums*)


IntegerPartitions[200, All, {1, 2, 5, 10, 20, 50, 100, 200}] // Length
(* 73682 *)


FrobeniusSolve[{1, 2, 5, 10, 20, 50, 100, 200}, 200] // Length


(* ::Section:: *)
(*32. Pandigital products*)


pandigitalQ[list_] := DuplicateFreeQ[list] && FreeQ[list, 0]
Join[
  Select[pandigitalQ @ Flatten @ IntegerDigits @ # &] @
    Catenate @ Outer[{#1, #2, #1 * #2} &, {2, 3, 4}, FromDigits /@ Permutations[Range[9], {4}]],
  With[{iRange = Select[pandigitalQ @ IntegerDigits @ # &] @ Range[12, 99],
        jRange = Select[pandigitalQ @ IntegerDigits @ # &] @ Range[102, 999]},
    Select[Apply[1000 <= #3 <= 9999 &&
           pandigitalQ @ Flatten @ IntegerDigits[{##}] &]] @
      Catenate @ Table[{i, j, i * j}, {i, iRange}, {j, jRange}]]
] /. {_, _, p_} -> p // Union // Total
(* 45228 *)


(* ::Section:: *)
(*33. Digit cancelling fractions*)


cancel[a_, b_] := First[Divide @@ (Complement[#, Intersection[a, b]] & /@ {a, b})]
Denominator[Times @@ Divide @@@ Echo[#]] & @
  Select[cancel @@ IntegerDigits[#] == Divide @@ # &] @
    Select[Length[Union @@ IntegerDigits[#]] == 3 &] @
      DeleteCases[_?(Or @@ Flatten @ Outer[Divisible, #, {10, 11}] &)] @
        Catenate @ Table[{i, j}, {j, 10, 99}, {i, 10, j - 1}]
(* {{16,64},{26,65},{19,95},{49,98}} *)
(* 100 *)


(* ::Section:: *)
(*34. Digit factorials*)


With[{n = n /. First @ NSolve[{10^n - 1 == 9! * n, n > 0}, n]},
  Total @ Select[Range[3, Ceiling[10^n]], # == Total[IntegerDigits[#]!] &]]
(* 40730 *)


(* ::Section:: *)
(*35. Circular primes*)


circularPrimeQ[n_] := And @@ PrimeQ[
  FromDigits @ RotateLeft[IntegerDigits[n], #] & /@ Range[IntegerLength[n] - 1]]
Length @ Select[Prime @ Range @ PrimePi[1*^6], circularPrimeQ]
(* 55 *)


(* ::Section:: *)
(*36. Double-base palindromes*)


Total @ Select[Range[1*^6], PalindromeQ[#] && PalindromeQ @ IntegerString[#, 2] &]
(* 872187 *)


(* ::Section:: *)
(*37. Truncatable primes*)


truncatablePrimeQ[n_] := With[{digits = IntegerDigits[n]},
  And @@ PrimeQ[
    FromDigits /@ Catenate[{digits[[;;#]], digits[[#;;]]} & /@ Range[Length @ digits]]]
]
Total @ Last @ NestWhile[
  Apply[{NextPrime[#1], If[truncatablePrimeQ[#1], Append[#2, #1], #2]} &],
  {11, {}},
  Apply[Length[#2] < 11 &]
]
(* 748317 *)


(* ::Section:: *)
(*38. Pandigital multiples*)


pandigitalQ[list_] := DuplicateFreeQ[list] && FreeQ[list, 0]


With[{f = #2 -> Catenate[IntegerDigits[#2 * Range[#1]]] &},
  FromDigits /@ Select[pandigitalQ] @ Association @ Flatten @
    {
      9 -> {9, 1, 8, 2, 7, 3, 6, 4, 5},
      MapThread[CurryApplied[f, 2][#1] /@ Range @@ #2 &] @
        Transpose @ {{4, {25, 33}}, {3, {100, 333}}, {2, {5000, 9999}}}
    }
] // TakeLargest[1]
(* <|9327 -> 932718654|> *)


FromDigits /@ Select[pandigitalQ] @ Association[
  # -> Catenate[IntegerDigits[# * {1, 2}]] & /@ Range[9123, 9876]] // TakeLargest[1]
(* <|9327 -> 932718654|> *)


(* ::Section:: *)
(*39. Integer right triangles*)


With[{pyTriples = Select[Apply[CoprimeQ]] @ Catenate @
    Table[Sort[{m^2-n^2, 2m*n, m^2+n^2}], {m, 20}, {n, m-1}]},
  TakeLargestBy[#, Last, 1][[1, 1]] & @ Tally @ Sort @ Select[# < 1000 &] @
    Flatten[(Total /@ pyTriples) * # & /@ Range[83]]]
(* 840 *)


a + b + c /. TakeLargestBy[
  Solve[{a^2 + b^2 == c^2, a + b + c == #, 0 < a < b < c}, {a, b, c}, Integers] & /@ Range[1000],
  Length, 1][[1, 1]] // AbsoluteTiming
(* {25.1451, 840} *)


(* ::Section:: *)
(*40. Champernowne's constant*)


Times @@ With[{n = RealDigits[N[ChampernowneNumber[], 1*^6]]}, n[[1, #]] & /@ PowerRange[1*^6]] // AbsoluteTiming
(* 210 *)
