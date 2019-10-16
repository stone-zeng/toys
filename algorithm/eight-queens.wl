(* ::Package:: *)

Remove["Global`*"]


queens[n_] := Select[Permutations @ Range @ n, isSafe]
isSafe[{x_, xs__}] := isSafe[{xs}] &&
  And @@ MapIndexed[Abs[x - #1] != First @ #2 &, {xs}]
isSafe[__] := True


(* Result: {1, 0, 0, 2, 10, 4, 40, 92} *)
AbsoluteTiming[Length /@ queens /@ Range[8]]


plot[conf_] := With[{n = Length @ conf, queen = "\[WhiteQueen]"},
  Grid[SparseArray[MapIndexed[{#1, First @ #2} -> queen &, conf], {n, n}, ""],
    Frame -> All, Background -> {None, None, Flatten[Thread /@ Thread[
      GatherBy[Tuples[{#, #}] & @ Range[n], EvenQ @* Total] ->
        RGBColor /@ {"#D18B47", "#FFCE9E"}]]}]]
plot /@ queens[8] // Partition[#, UpTo @ 5] & // Grid
