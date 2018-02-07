(* ::Package:: *)

(* ::Section:: *)
(*Load data*)


Remove["Global`*"]


rawData = Import["risk-parity.csv", "Data"][[2;;]];


indicesNumber = Length[rawData[[1, 2;;]]]


ratio = Ratios[rawData[[All, 2;;]]]-1;
Dimensions[ratio]
date = DateObject /@ (rawData[[2;;, 1]]);
Dimensions[date]


ratioDateAssoc = AssociationThread[date -> ratio];
indexKeyAssoc  = First /@ PositionIndex @ Keys @ ratioDateAssoc;


beginDate = DateObject["2015/1/1"]
endDate = Last @ date


(* ::Section:: *)
(*Calculate covariance*)


(* If the date is not exist,  then check the next day. *)
lookupDateValue[$assoc_, $date_]:=
  Last @ NestWhileList[
    {DatePlus[#[[1]], 1], $assoc[DatePlus[#[[1]], 1]]}&,
    {DatePlus[$date, -1], Missing[]}, MissingQ[#[[2]]]&]


getAdjustPeroidList[$assoc_, $adjustPeriod_, $beginDate_, $endDate_]:=
  Map[lookupDateValue[$assoc, #]&,
    NestWhileList[DatePlus[#, $adjustPeriod]&, $beginDate, LessThan[$endDate]][[;;-2]]][[All, 1]]


getValueMatrices[$assoc_, $indexAssoc_, $dateBeginList_, $dateEndList_]:=
  Map[Values @ $assoc[[(#[[1]] /. $indexAssoc) ;; (#[[2]]/.$indexAssoc)]]&,
    Transpose @ {$dateBeginList, $dateEndList}]
(*
  (* This one is too slow! *)
  getValueMatrices[$dateBeginList_, $dateEndList_]:=
    ParallelMap[Values @ KeySelect[ratioDateAssoc, Function[$date, #[[1]] <= $date <= #[[2]]]]&,
      Transpose @ {$dateBeginList, $dateEndList}]
*)
(*
  (* TEST *)
  MatrixForm[m = First @ getValueMatrices[ratioDateAssoc, indexKeyAssoc,
    DateObject /@ {"20100105"}, DateObject /@ {"20100120"}]]
  Fold[Times] /@ Transpose @ (m + 1)
  findLargestIndex[%, 4]
  m[[All,Sort @ %]] // MatrixForm
  Clear[m]
*)


findLargestIndex[$list_, $n_:1]:=
  Part[#, 2]& /@ TakeLargestBy[Transpose[{$list, Range @ Length @ $list}], #[[1]]&, $n]
(* 
  (* TEST *)
  findLargestIndex[{156, 16, 894, 2, 9496, 14}]
  findLargestIndex[{156, 16, 894, 2, 9496, 14}, 4]
*)


(* Argument format: {n,  "DateType"} *)
calcCovariance[$timeWindow_, $adjustPeriod_]:=
  With[{$endDate = getAdjustPeroidList[ratioDateAssoc, $adjustPeriod, beginDate, endDate]},
    With[{$rawBeginDate = DatePlus[#, $timeWindow /. {t_, s_} -> {-t, s}]& /@ $endDate},
      With[{$beginDate = (lookupDateValue[ratioDateAssoc, #]& /@ $rawBeginDate)[[All, 1]]},
        DeleteDuplicates @ Map[Apply @ Rule, Transpose @
          {$endDate, Covariance /@
            getValueMatrices[ratioDateAssoc, indexKeyAssoc, $beginDate, $endDate]}]
  ]]]


getRMIndices[$adjustPeriod_, $momentumPeriod_, $num_]:=
  With[{$endDate = getAdjustPeroidList[ratioDateAssoc, $adjustPeriod, beginDate, endDate]},
    With[{$rawBeginDate = DatePlus[#, $momentumPeriod /. {t_, s_}->{-t, s}]& /@ $endDate},
      With[{$beginDate = (lookupDateValue[ratioDateAssoc, #]& /@ $rawBeginDate)[[All, 1]]},
        findLargestIndex[#, $num]& /@ Map[Fold[Times], #, {2}]& @
            (Transpose /@ getValueMatrices[ratioDateAssoc, indexKeyAssoc, $beginDate, $endDate] + 1)
  ]]]
(*
  (* TEST *)
  getRMIndices[{100, "Day"}, {1, "Month"}, 4]
*)


(* Argument format: {n,  "DateType"} *)
(* "RM" means Relative Momentum      *)
calcCovarianceRM[$timeWindow_, $adjustPeriod_, $indices_]:=
  With[{$endDate = getAdjustPeroidList[ratioDateAssoc, $adjustPeriod, beginDate, endDate]},
    With[{$rawBeginDate = DatePlus[#, $timeWindow /. {t_, s_}->{-t, s}]& /@ $endDate},
      With[{$beginDate = (lookupDateValue[ratioDateAssoc, #]& /@ $rawBeginDate)[[All, 1]]},
        DeleteDuplicates @ Map[Apply @ Rule, Transpose @
          {$endDate, Covariance /@ MapThread[
            Part[#1, All, #2]&,
            {getValueMatrices[ratioDateAssoc, indexKeyAssoc, $beginDate, $endDate], $indices}]
          }]
  ]]]
(*
  (* TEST *)
  MatrixForm/@calcCovarianceRM[{6, "Month"}, {100, "Day"},
    getRMIndices[{100, "Day"}, {3, "Month"}, 2]]
*)


(* ::Section:: *)
(*Solve for weights*)


solveWeights[$Sigma_]:=
  With[{$dim = Length[$Sigma]},
    Module[{$w = ToExpression /@ (("w" <> ToString[#])& /@ Range[$dim])},
      $w /. NSolve[Flatten @ {Equal @@ ($w * $Sigma . $w / Sqrt[$w . $Sigma . $w]),
        Total[$w] == 1.0, Greater[#, 0]& /@ $w}, $w][[1]]
  ]]


solveWeightsRMAux[$Sigma_, $indices_]:=
  Module[{$w = ToExpression /@ (("w" <> ToString[#])& /@ $indices)},
      $w /. NSolve[Flatten @ {Equal @@ ($w * $Sigma . $w / Sqrt[$w . $Sigma . $w]),
        Total[$w] == 1.0, Greater[#, 0]& /@ $w}, $w][[1]]
  ]
solveWeightsRM[$Sigma_, $indices_]:=
  Normal @ SparseArray[#, indicesNumber]& /@ Thread /@
    MapThread[Rule, {$indices, MapThread[solveWeightsRMAux, {Values @ $Sigma, $indices}]}]
(*
  (* TEST *)
  indices = getRMIndices[{100, "Day"}, {3, "Month"}, 2]
  cov = calcCovarianceRM[{6, "Month"}, {100, "Day"}, indices];
  weights = MapThread[solveWeightsRMAux, {Values @ cov, indices}]
  solveWeightsRM[cov, indices]
  Clear[indices, cov, weights]
*)


getYieldRate[$dateList_]:=
  With[{$index = indexKeyAssoc /@ $dateList},
    Fold[Times] /@ (ratio[[#]]& /@ MapThread[Span, {$index[[;;-2]], $index[[2;;]] - 1}] + 1)]


getProfit[$weightList_, $dateList_]:=
  FoldList[Times, 1, #]& /@
    {MapThread[Dot, {$weightList, getYieldRate @ $dateList}], Mean /@ getYieldRate @ $dateList}


getXTicks[$dateList_, $span_]:=
  Transpose[{Range[Length @ $dateList],
    DateString[#, {"YearShort", "-", "Month"}]& /@ $dateList}][[$span]]


plotWeight[$weightList_, $xTicks_:Automatic]:=
  StackedListPlot[Transpose @ $weightList, PlotRange -> All,
    FrameTicks -> {$xTicks, {#, ToString[Round[# * 100]] <> "%"}& /@ Range[0, 1, 0.2]},
    PlotTheme -> "Business", PlotMarkers -> None, PlotLegends -> {"A", "B", "C", "D", "E"}]


plotProfit[$profitList_, $xTicks_:Automatic]:=
  ListPlot[$profitList, Joined -> True, PlotRange -> {0.8, 2.0},
    FrameTicks -> {$xTicks, Automatic},
    PlotTheme -> "Business", PlotMarkers -> None, PlotLegends -> {"Equal risk", "Equal weight"}]


(* ::Section:: *)
(*Test*)


(*
timeWindow   = {6, "Month"};
adjustPeriod = {100, "Day"};
AbsoluteTiming[cov = calcCovariance[timeWindow, adjustPeriod];]
AbsoluteTiming[weights = ParallelMap[solveWeights, Values @ cov];]
AbsoluteTiming[profit = getProfit[weights[[;;-2]], Keys @ cov];]
*)


timeWindow   = {2, "Year"};
adjustPeriod = {30, "Day"};
momentum     = {0, "Month"};
number       = 3;
AbsoluteTiming[indices = getRMIndices[adjustPeriod, momentum, number];]
AbsoluteTiming[cov = calcCovarianceRM[timeWindow, adjustPeriod, indices];]
AbsoluteTiming[weights = solveWeightsRM[cov, indices];]
AbsoluteTiming[profit = getProfit[weights[[;;-2]], Keys @ cov];]


xTicks = getXTicks[Keys @ cov, 1;;-1;;10];
plotWeight[weights, xTicks]
plotProfit[profit, xTicks]
