(* ::Package:: *)

SetDirectory[NotebookDirectory[]];
img = Import["win-colors.png"]


cellSize = 46;
Flatten @ ImagePartition[img, cellSize];
colorList = ParallelMap[
  First @ DominantColors[#, 1, {"Color", "NearestHTMLColor","HexRGBColor"}]&, %]


"colors" -> (colorList /. {color_, html_, hex_} -> {"nearestHTMLname" -> html, "hex" -> hex});
Export["win-colors.json", {%}];
