(* ::Package:: *)

(* ::Chapter:: *)
(*Exact diagonalization: Ising model*)


Remove["Global`*"]
SetDirectory[NotebookDirectory[]]


{sigmaI, sigmaX, sigmaZ} = SparseArray /@ PauliMatrix /@ {0, 1, 3};


getMatrix[siteNum_, couplingConst_] :=
  -couplingConst * Total @ directProductMatrix[{sigmaZ, sigmaZ}, siteNum] +
  Total @ directProductMatrix[{sigmaX}, siteNum]
directProductMatrix[matrices_, n_] :=
  KroneckerProduct @@@ NestList[RotateRight, PadRight[matrices, n, {sigmaI}], n - 1]


getEigensystem[matrix_, num_: 1] :=
  -Eigensystem[N[-matrix], num, Method -> {"Arnoldi", "Criteria" -> "RealPart", "MaxIterations" -> 3000}]
getGroundEigensystem[matrix_] :=
  First /@ getEigensystem[matrix, 1]


getMagnetization[groundState_, siteNum_] :=
  Mean[(groundState . # . groundState) & /@ directProductMatrix[{sigmaX}, siteNum]]


differencesWithLast[list_] :=
  Append[Differences @ list, Last @ list]


nRange = Range[3, 13, 2];
kRange = PowerRange[.01, 100, Surd[10, 5]](*Range[0, 20, .1]*);
test[n_] := Module[{matrices, states},
  matrices = ParallelTable[getMatrix[n, k], {k, kRange}];
  states = ParallelMap[Function[m, getEigensystem[m, 2]], matrices];
  <|
    "e0" -> #[[1, 1]] / n,
    "gap" -> -Subtract @@ (First @ #),
    "mz"  -> getMagnetization[#[[2, 2]], n]
  |> & /@ states]

result = {};
Echo[AbsoluteTiming[AppendTo[result, test @ #];], "N = " <> ToString @ # <> ": "] & /@ nRange;
result = Prepend[Merge[Merge[Flatten[#, 1] &] /@ result, Apply @ List],
  {"nRange" -> nRange, "kRange" -> kRange}];

plotFunc[key_, label_, opts: OptionsPattern[]] :=
  ListLinePlot[Transpose @ {kRange, #} & /@ result[key],
    PlotRange -> All,
    PlotTheme -> "Detailed",
    ScalingFunctions -> {"Log", None},
    Mesh      -> All,
    ImageSize -> 400,
    PlotLabel -> label,
    FilterRules[{opts}, Options[ListLinePlot]]]
Row[{
  plotFunc["e0", ""],
  plotFunc["gap", ""],
  plotFunc["mz", "", PlotLegends -> nRange]}]


Transpose @ {kRange, #} & /@ result["e0"];
f = Interpolation /@ %;
LogLinearPlot[Evaluate[#[x] & /@ f], {x, 0.1, 100}]
LogLinearPlot[Evaluate[#'[x] & /@ f], {x, 0.1, 100}]



