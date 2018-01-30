(* ::Package:: *)

Remove["Global`*"]


(* ::Section:: *)
(*Functions*)


(* ::Subsection:: *)
(*Internal functions*)


initialize[size_, time_] := RandomChoice[{-1.0, 1.0}, {size, time}]


calcMatrix$k[arg$mu_, size_] :=
  Normal @ SparseArray[{Band[{1, 1}] -> arg$mu, Band[{2, 1}] -> 1, Band[{1, 2}] -> 1}, {size, size}]


calcMatrices$v[matrix$s_, time_] :=
  DiagonalMatrix[(Transpose @ matrix$s)[[#]]]& /@ Range[time]


calcMatrices$B[matrix$s_, matrix$k_, spin_, arg$dtau_, arg$lambda_, time_] :=
  With[{matrices$v = calcMatrices$v[matrix$s, time]},
    (MatrixExp[-arg$dtau * matrix$k] . MatrixExp[-spin * arg$dtau * arg$lambda * matrices$v[[#]]])&
    /@ Range[time]]


calcMatrices$G[matrices$B_, time$index_, size_] :=
  Inverse[IdentityMatrix[size] + Dot @@ RotateRight[Reverse@matrices$B, time$index]]


calcMatrices$Delta[s_, lattice$index_, spin_, arg$dtau_, arg$lambda_, size_] :=
  SparseArray[{{lattice$index, lattice$index} -> Exp[2 spin * arg$dtau * arg$lambda * s] - 1},
    {size, size}]


calcR[matrices$G_, matrices$Delta_, lattice$index_, time$index_, spin_] :=
  1 + (1 - matrices$G[[time$index, spin, lattice$index, lattice$index]]) *
    matrices$Delta[[spin, lattice$index, lattice$index]]


(* ::Subsection:: *)
(*Main functions*)


Options[simulateSingle] = {RebuildPeriod -> 1};


simulateSingle[size_, time_, arg$U_, arg$mu_, arg$beta_, OptionsPattern[]] :=
  With[{dtau = arg$beta/time},
    With[{lambda = 1 / dtau * ArcCosh @ Exp[(arg$U * dtau) / 2]},
      $k = calcMatrix$k[arg$mu, size];
      $s = initialize[size, time];
      $B = calcMatrices$B[$s, $k, #, dtau, lambda, time]& /@ {1, -1};
      $G = {calcMatrices$G[#, 1, size]& /@ $B};

      (* Main loop *)
      Do[
        If[Divisible[index$l, OptionValue @ RebuildPeriod],
          $G[[index$l]] = calcMatrices$G[#, index$l, size]& /@ $B];

        Do[
          $Delta = calcMatrices$Delta[$s[[index$i, index$l]], index$i, #, dtau, lambda, size]&
            /@ {1, -1};
          $R = calcR[$G, $Delta, index$i, index$l, #]& /@ {1, -1};
          (* Update s *)
          $s[[index$i, index$l]] *= 1 - 2 UnitStep[Times @@ $R - RandomReal[]];
          (* Update Green functions *)
          $Delta = calcMatrices$Delta[$s[[index$i, index$l]], index$i, #, dtau, lambda, size]&
            /@ {1, -1};
          $G[[index$l]] -= (1 / $R[[#]] ($G[[index$l, #]] . $Delta[[#]] .
            (IdentityMatrix[size] - $G[[index$l, #]]))& /@ {1, -1});,
        {index$i, size}];

        $B = calcMatrices$B[$s, $k, #, dtau, lambda, time]& /@ {1, -1};

        If[index$l < time,
          (* index$l < time *)
          AppendTo[$G, $B[[#, index$l + 1]] . $G[[index$l, #]] . Inverse @ $B[[#, index$l + 1]]&
            /@ {1, -1}];,
          (* index$l == time *)
          $G[[1]] = $B[[#, 1]] . $G[[time, #]] . Inverse @ $B[[#, 1]]& /@ {1, -1};];,

      (* End of main loop *)
      {index$l, time}];

      (* Output *)
      {$G, Clear[$k, $s, $B, $G, $Delta, $R]}[[1]]
    ]
  ]


(* ::Subsection:: *)
(*Measurements*)


$calcInvertSpin[matrices$G_, spin_, size_] :=
  Table[(1 - matrices$G[[spin, i, i]]) (1 - matrices$G[[-spin, j, j]]), {j, size}, {i, size}]


$calcLikeSpin[matrices$G_, spin_, size_] :=
  Table[(1 - matrices$G[[spin, i, i]]) (1 - matrices$G[[spin, j, j]]) +
    (KroneckerDelta[i, j] - matrices$G[[spin, j, i]]) * matrices$G[[spin, i, j]],
  {j, size}, {i, size}]


calcSpinCorr[matrices$G_] :=
  Mean @ With[{size = Length@matrices$G[[1, 1]]},
    Mean /@ Flatten /@ ((Table[(-1)^(i-j), {j, size}, {i, size}] *
      ($calcLikeSpin[#, +1, size] - $calcLikeSpin[#, -1, size] +
        $calcInvertSpin[#, +1, size] - $calcInvertSpin[#, -1, size]))&
      /@ matrices$G)]


$calcEnergyI[matrices$G_, size_] :=
  With[{m = Table[2 KroneckerDelta[i, j] - matrices$G[[#, i, j]] - matrices$G[[#, j, i]],
      {i, size}, {j, size}]& /@ {1, -1}},
    Total @ Flatten @ Table[Diagonal[m[[i]], j], {i, {1, -2}}, {j, {-1, 1}}]]


$calcEnergyII[matrices$G_, size_] := Total @ Diagonal @ $calcInvertSpin[matrices$G, +1, size]


$calcEnergyIII[matrices$G_, size_] :=
  Sum[(1 - matrices$G[[+1, i, i]]) + (1 - matrices$G[[-1, i, i]]), {i, size}]


calcEnergy[matrices$G_, arg$U_, arg$mu_] :=
  Mean @ With[{size = Length[matrices$G[[1, 1]]]},
    1 / size * (-$calcEnergyI[#, size] + arg$U*$calcEnergyII[#, size] -
      (arg$mu + 1/2 arg$U) * $calcEnergyIII[#, size])&
    /@ matrices$G]


(* ::Section:: *)
(*Simulation*)


U     = 4.0;
mu    = U / 2;
beta  = N @ {1, 20, 1};
batch = 5;
size  = 4;


beta$list = Table[i, Evaluate @ Flatten @ {i, beta}];


SetOptions[$FrontEnd, MessageOptions -> {"KernelMessageAction" -> "PrintToConsole"}]

$KernelCount; (* load the Parallel` code *)

Unprotect[MessagePacket]; (* patch MessagePacket upvalue *)

MessagePacket /:
  Parallel`Protected`PacketHandler[t : MessagePacket[sym_, tag_, text_],
      Parallel`Kernels`kernel_] :=
    NotebookWrite[MessagesNotebook[],
      Cell[text, "Message", "MSG",
        CellLabel -> Parallel`Kernels`Private`kernelString[Parallel`Kernels`kernel],
        ShowCellLabel -> True]]


Echo[#, "Simulation time: "]& @ AbsoluteTiming[
  G = ParallelTable[
    simulateSingle[size, Round[8 $beta], U, mu, $beta, RebuildPeriod -> 1],
  {$beta, beta[[1]], beta[[2]], beta[[3]]}, {$batch, batch}, Method -> "FinestGrained"];][[1]];


Echo[#, "Correlation evaluation time: "]& @ AbsoluteTiming[
  spinCorr = Mean /@ ParallelMap[calcSpinCorr, G, {2}, Method -> "FinestGrained"];][[1]];
Echo[#, "Energy evaluation time: "]& @ AbsoluteTiming[
  energy = Mean /@ ParallelMap[calcEnergy[#, U, mu]&, G, {2}, Method -> "FinestGrained"];][[1]];


#[Transpose @ {beta$list, spinCorr},
  Joined -> True, Mesh -> All, PlotRange -> All]& /@ {ListPlot, ListLogPlot}
#[Transpose @ {beta$list, energy},
  Joined -> True, Mesh -> All, PlotRange -> All]& /@ {ListPlot, ListLogPlot}
