(* ::Package:: *)

Remove["Global`*"]


queens[n_] := Select[Permutations @ Range @ n, isSafe]
isSafe[{x_, xs__}] := isSafe[{xs}] && And @@ MapIndexed[Abs[x - #1] != First @ #2 &, {xs}]
isSafe[__] := True


(* Result: {1, 0, 0, 2, 10, 4, 40, 92} *)
AbsoluteTiming[Length /@ queens /@ Range[8]]
