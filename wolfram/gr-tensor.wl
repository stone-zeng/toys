(* ::Package:: *)

Remove["Global`*"]


(* ::Section:: *)
(*Calculate*)


initializeMetric[raw$metric_, coord_] :=
  <|
    "Coordinate" -> coord,
    "Dimension" -> Length @ coord,
    "Metric" -> raw$metric,
    "InversedMetric" -> Simplify @ Inverse @ raw$metric
  |>


calcConnections[metric_Association] :=
  With[{coord = metric["Coordinate"], m = metric["Metric"], n = metric["Dimension"]},
    Append["Connections" -> Simplify @ Table[
      Sum[metric["InversedMetric"][[i, s]] / 2 *
        (D[m[[s, j]], coord[[k]]] + D[m[[s, k]], coord[[j]]] - D[m[[j, k]], coord[[s]]]), {s, n}],
      {i, n}, {j, n}, {k, n}]] @ metric]


calcRiemannTensors[metric_Association] :=
  With[{coord = metric["Coordinate"], c = metric["Connections"], n = metric["Dimension"]},
    Append["RiemannTensors" -> Simplify @ Table[
      D[c[[i, j, l]], coord[[k]]] - D[c[[i, j, k]], coord[[l]]] +
        Sum[c[[s, j, l]] * c[[i, k, s]] - c[[s, j, k]] * c[[i, l, s]], {s, n}],
      {i, n}, {j, n}, {k, n}, {l, n}]] @ metric]


calcRicciTensors[metric_Association] :=
  With[{n = metric["Dimension"]},
    Append["RicciTensors" -> Simplify @ Table[
      Sum[metric["RiemannTensors"][[i, j, i, l]], {i, n}],
      {j, n}, {l, n}]] @ metric]


calcScalarCurvature[metric_Association] :=
  With[{n = metric["Dimension"]},
    Append["ScalarCurvature" -> Simplify @ Sum[
      metric["InversedMetric"][[i, j]] * metric["RicciTensors"][[i, j]],
      {i, n}, {j, n}]] @ metric]


calcEinsteinTensors[metric_Association] :=
  Append["EinsteinTensors" -> Simplify[
    metric["RicciTensors"] - metric["ScalarCurvature"] * metric["Metric"] / 2]] @ metric


GRTensorCalculate[raw$metric_, coord_] :=
  RightComposition[
    initializeMetric,
    calcConnections,
    calcRiemannTensors,
    calcRicciTensors,
    calcScalarCurvature,
    calcEinsteinTensors][raw$metric, coord]


(* ::Section:: *)
(*Show*)


GRTensor::keym = "Key `1` is missing.";


echoList[list_List, key_] :=
  If[Length[list] == 0,
    Echo["All " <> key <> " vanish."];,
    Echo @@@ list;]


showConnections[metric_Association] :=
  If[KeyExistsQ[metric, "Connections"],
    With[{c = metric["Connections"], n = metric["Dimension"]},
      echoList[#, "connections"] & @ DeleteCases[Null] @ Flatten[#, 2] & @
        Table[If[c[[i, j, k]] =!= 0, {c[[i, j, k]], Subscript[Superscript["\[CapitalGamma]", i], j, k]}],
          {i, n}, {j, n}, {k, j}]],
    Message[GRTensor::keym, "Connections"]]


showRiemannTensors[metric_Association] :=
  If[KeyExistsQ[metric, "RiemannTensors"],
    With[{r = metric["RiemannTensors"], n = metric["Dimension"]},
      echoList[#, "Riemann tensors"] & @ DeleteCases[Null] @ Flatten[#, 3] & @
        Table[If[r[[i, j, k, l]] =!= 0, {r[[i, j, k, l]], Subscript[Superscript["R", i], j, k, l]}],
          {i, n}, {j, n}, {k, n}, {l, k - 1}];],
    Message[GRTensor::keym, "RiemannTensors"]]


showRicciTensors[metric_Association] :=
  If[KeyExistsQ[metric, "RicciTensors"],
    With[{ric = metric["RicciTensors"], n = metric["Dimension"]},
      echoList[#, "Ricci tensors"] & @ DeleteCases[Null] @ Flatten[#, 1] & @
        Table[If[ric[[j, l]] =!= 0, {ric[[j, l]], Subscript["R", j, l]}], {j, n}, {l, j}];],
    Message[GRTensor::keym, "RicciTensors"]]


showScalarCurvature[metric_Association] :=
  If[KeyExistsQ[metric, "ScalarCurvature"],
    Echo[metric["ScalarCurvature"], "Scalar curvature"];,
    Message[GRTensor::keym, "ScalarCurvature"]]


showEinsteinTensors[metric_Association] :=
  If[KeyExistsQ[metric, "EinsteinTensors"],
    With[{e = metric["EinsteinTensors"], n = metric["Dimension"]},
      echoList[#, "Einstein tensors"] & @ DeleteCases[Null] @ Flatten[#, 1] & @
        Table[If[e[[j, l]] =!= 0, {e[[j, l]], Subscript["G", j, l]}], {j, n}, {l, j}];],
    Message[GRTensor::keym, "EinsteinTensors"]]


GRTensorShow[metric_Association] :=
  #[metric] & /@ {
    showConnections,
    showRiemannTensors,
    showRicciTensors,
    showEinsteinTensors,
    showScalarCurvature}


(* ::Section:: *)
(*Metrics*)


metricSchwarzschild = DiagonalMatrix @
  {1 / (1 - 2m / r), r^2, r^2 * Sin[\[Theta]]^2, -(1 - 2m / r)} /. m -> G M / c^2;
metricSchwarzschildDeSitter = DiagonalMatrix @
  {1 / (1 - 2m / r - r^2), r^2, r^2 * Sin[\[Theta]]^2, -(1 - 2m / r - r^2)} /. m -> G M / c^2;
metricReissnerNordstrom = DiagonalMatrix @
  {1 / (1 - 2m / r + rQ^2 / r^2), r^2, r^2 * Sin[\[Theta]]^2, -(1 - 2m / r + rQ^2 / r^2)} /.
    {m -> G M / c^2, rQ^2 -> (G Q^2) / (4Pi \[CurlyEpsilon]0 c^4)};
metricKerr = Simplify[(DiagonalMatrix[{\[CapitalSigma] / \[CapitalDelta], \[CapitalSigma], (\[CapitalDelta] + 2m r(r^2 + a^2)) * Sin[\[Theta]]^2, -(1 - 2m r / \[CapitalSigma])}] +
  Normal @ SparseArray[{{3, 4}, {4, 3}} -> -2m r a Sin[\[Theta]]^2 / \[CapitalSigma] * {1, 1}, {4, 4}]) //.
    {m -> G M / c^2, \[CapitalSigma] -> r^2 + a^2 * Cos[\[Theta]]^2, \[CapitalDelta] -> r^2 - 2m r + a^2}];
metricRobertsonWalker = DiagonalMatrix @
  {R[t]^2 / (1-k r^2), R[t]^2 r^2, R[t]^2 r^2 * Sin[\[Theta]]^2, -1};


(* ::Section:: *)
(*Test*)


coord = {r, \[Theta], \[Phi], t};
AbsoluteTiming[result = GRTensorCalculate[metricSchwarzschildDeSitter, coord];]
GRTensorShow[result];
