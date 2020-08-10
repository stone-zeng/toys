(* ::Package:: *)

(* ::Title:: *)
(*Project Euler (21\[Dash]30)*)


(* ::Section:: *)
(*21. Amicable numbers*)


(* Too slow! *)
findAmicablePairs = Compile[{{n, _Integer}},
  Module[{sum = 0, x},
    Do[
      x = i + j; If[DivisorSigma[1, i] == x && DivisorSigma[1, j] == x, sum += x],
      {j, n}, {i, j - 1}
    ];
    sum],
  CompilationTarget -> "C"];
findAmicablePairs[10000] // AbsoluteTiming
(* {119.510203, 31626} *)


With[{f = DivisorSigma[1, #] - # &},
  Total @ DeleteCases[Select[Range[10000], f[f[#]] == # &], _?PerfectNumberQ]]
(* 31626 *)


(* ::Section:: *)
(*22. Names scores*)


With[{data = Import["https://projecteuler.net/project/resources/p022_names.txt", "String"]},
Total @ Flatten @ MapIndexed[Total[ToCharacterCode[#1] - 64] * #2 &] @
  Sort @ StringSplit[StringDelete[data, "\""], ","]]
(* 871198282 *)


(* ::Section:: *)
(*23. Non-abundant sums*)


With[{n = 28123},
  Total @ Complement[Range[n], Union[Total /@ Subsets[#, {2}], 2#]] & @
    Select[Range[n], DivisorSigma[1, #] > 2# &]]
(* 4179871 *)


(* ::Section:: *)
(*24. Lexicographic permutations*)


FromDigits @ Part[Permutations[Range[0, 9]], 1*^6]
(* 2783915460 *)


(* ::Section:: *)
(*25. 1000-digit Fibonacci number*)


NestWhile[# + 1 &, 1, IntegerLength[Fibonacci[#]] < 1000 &]
(* 4782 *)


(* ::Section:: *)
(*26. Reciprocal cycles*)


First @ MaximalBy[Range[1000], Length @ RealDigits[1 / #][[1, 1]] &]
(* 983 *)


(* ::Section:: *)
(*27. Quadratic primes*)


qPrimesCount[a_, b_] := NestWhile[# + 1 &, 0, PrimeQ[#^2 + a # + b] &]
Times @@ First @ MaximalBy[Apply[qPrimesCount]] @ Catenate @
  Table[{a, b}, {a, Range[-999, 999, 2]}, {b, Prime @ Range[2, PrimePi[1000]]}]
(* -59231 *)


(* ::Section:: *)
(*28. Number spiral diagonals*)


Total[Total[n^2 - (n-1) * Range[0, 3]] /. n -> Range[3, 1001, 2]] + 1
(* 669171001 *)


(* ::Section:: *)
(*29. Distinct powers*)


Union @@ Table[a^b, {a, 2, 100}, {b, 2, 100}] // Length
(* 9183 *)


(* ::Section:: *)
(*30. Digit fifth powers*)


Total @ Select[{#, Total[IntegerDigits[#]^5]} & /@ Range[2*^5], Apply[#1 == #2 &]][[2;;, 1]]
(* 443839 *)
