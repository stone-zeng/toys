(* ::Package:: *)

(* ::Title:: *)
(*\[MathematicaIcon] in practical use: COVID-19 in the US*)


(* ::Text:: *)
(*Import data from wherever:*)


rawData = Import["https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"];
(* rawData = Import[NotebookDirectory[] <> "us-states.csv"]; *)


(* ::Text:: *)
(*Check the data format:*)


rawData // Dimensions
rawData[[;;10]] // Dataset
rawData[[;;3]] // InputForm


(* ::Text:: *)
(*Convert it to be what we need (remove the first row & "fips" column):*)


data = rawData[[2;;, {1,2,4,5}]];
data[[;;10]] // Dataset


Select[data, #[[2]] == "Washington" && #[[3]] > 100 &];
(* Or Cases[data, {_, "Washington", __}] *)
% /. {date_, _, cases_, _} :> {DayCount[%[[1, 1]], date], cases};
ListLogPlot[%]


states = data\[Transpose][[2]] // Union
% // Length


dataPerSate[state_] :=
  Module[{$data = Select[data, #[[2]] == state && #[[3]] >= 100 &], firstDay},
    If[$data == {}, {},
      firstDay = $data[[1, 1]];
      $data /. {date_, _, cases_, _} :> {DayCount[firstDay, date] + 1, cases}
    ]
  ]
dataPerSate["Vermont"]


sanitizedData = Association @ ParallelMap[# -> dataPerSate[#] &, states];


DeleteCases[sanitizedData, {}];
ReverseSortBy[%, Last @* Last][[;;20]];
ListPlot[%,
  PlotRange   -> All,
  Joined      -> True,
  PlotTheme   -> "Business",
  PlotLegends -> None,
  PlotLabels  -> Automatic,
  ImageSize   -> 800]


waData = dataPerSate["Washington"];
nlm = NonlinearModelFit[waData, {a/(1 + b * k^x) + c, 0 < k < 5}, {a, b, c, k}, x]
nlm["RSquared"]
nlm["ParameterTable"]
Show[
  Plot[nlm[t], {t, 0, 50}, PlotRange->All],
  ListPlot[waData]
]
