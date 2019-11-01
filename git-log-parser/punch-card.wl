(* ::Package:: *)

Remove["Global`*"]


SetDirectory[NotebookDirectory[]];


(* ::Section:: *)
(*Old Lua solution (deprecated)*)


(*
Run["git log"
  <> " --pretty=format:\"BEGIN%n"
  <> "  %x22commit%x22: %x22%H%x22,%n"
  <> "  %x22subject%x22: %x22%f%x22,%n"
  <> "  %x22date%x22: %x22%ai%x22,\""
  <> " --shortstat"
  <> " > git-log.log"];
Run["texlua git-log-json.lua"];
Run["del git-log.log"];
*)


(* ::Section:: *)
(*Get Git log*)


logFileName = "git-log-" <> Hash[Now[], "SHA256", "HexString"] <> ".log";


Run["git log"
  <> " --pretty=format:\"@BEGIN%n"
  <> " @COMMIT>%h<@COMMIT%n"
  <> " @SUBJECT>%s<@SUBJECT%n"
  <> " @DATE>%ai<@DATE\""
  <> " --shortstat"
  <> " --all"
  <> " > " <> logFileName];
gitLog = Import[logFileName, "Text"];
DeleteFile[logFileName]


(* ::Section:: *)
(*Parse*)


commitPattern    = "@COMMIT>" ~~ commit : WordCharacter.. ~~ "<@COMMIT" -> commit;
subjectPattern   = "@SUBJECT>" ~~ subject___ ~~ "<@SUBJECT" -> subject;
datePattern      = "@DATE>" ~~ date__ ~~ "<@DATE" -> date;
filePattern      = file : DigitCharacter.. ~~ Whitespace ~~ "file" -> file;
insertionPattern = insertion : DigitCharacter.. ~~ Whitespace ~~ "insertion" -> insertion;
deletionPattern  = deletion : DigitCharacter.. ~~ Whitespace ~~ "deletion" -> deletion;


parseGitLogItem[str_] := Association @
  {
    "commit"        -> First @ StringCases[str, commitPattern],
    "subject"       -> First @ StringCases[str, subjectPattern],
    "date"          -> First @ StringCases[str, datePattern],
    "files-changed" -> ToExpression @ First @ (StringCases[str, filePattern] /. {} -> {"0"}),
    "insertions"    -> ToExpression @ First @ (StringCases[str, insertionPattern] /. {} -> {"0"}),
    "deletions"     -> ToExpression @ First @ (StringCases[str, deletionPattern] /. {} -> {"0"})
  }


Length[list = parseGitLogItem /@ StringSplit[gitLog, "@BEGIN"]]


(* ::Section:: *)
(*Plot*)


dateListRaw = "date" /. list[[#]]& /@ Range[Length @ list];


dateList   = DateObject @ (#[[1]] <> " " <> #[[2]])& /@ StringSplit /@ dateListRaw;
timeList   = TimeObject @ #[[2]]& /@ StringSplit /@ dateListRaw;
commitList = {"insertions", "deletions"} /. list;


dateCount = {DateValue[#, "Hour"], DateValue[#, "ISOWeekDay"]}& /@ dateList;


DateHistogram[dateList, "Week", DateTicksFormat -> {"Year", "/", "Month"},
  PlotTheme -> "HeightGrid", AspectRatio -> 1/3, ImageSize -> 400, PlotLabel -> "Commits"]
DateHistogram[timeList, "Hour", DateTicksFormat -> {"Hour24Short", ":", "Minute"},
  PlotTheme -> "HeightGrid", AspectRatio -> 1/3, ImageSize -> 400, PlotLabel -> "Commits in the day"]


yTick = Transpose @ {Range[7], {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"}};
BubbleChart[Flatten /@ Tally[dateCount],
  AspectRatio -> 1/2.4, ImageSize -> 750, FrameTicks -> {{yTick, None}, {Range[0, 23, 2], None}},
  PlotTheme -> "HeightGrid", PlotLabel -> "Punch card", PerformanceGoal -> "Speed"]


DateListPlot[{Transpose @ {dateList, commitList /. {x_, y_} -> x},
    Transpose @ {dateList, commitList /. {x_, y_} -> -y}},
  PlotRange -> All, Filling -> Axis, PlotTheme -> "Detailed",
  PlotStyle -> {RGBColor[0.560181, 0.691569, 0.194885], RGBColor[0.922526, 0.385626, 0.209179]},
  PlotLabel -> "Code frequency"]


dateCommitGroup   = GroupBy[Transpose @
  {DayRound[#1, Sunday, "Preceding"]& /@ dateList, commitList}, First];
dateListPerWeek   = Keys @ dateCommitGroup;
commitListPerWeek = Map[Total, Transpose /@
  (Values @ dateCommitGroup /. {x_DateObject, y_} -> y), {2}];


DateListPlot[{Transpose @ {dateListPerWeek, commitListPerWeek /. {x_, y_} -> x},
    Transpose @ {dateListPerWeek, commitListPerWeek /. {x_, y_} -> -y}},
  PlotRange -> All, Filling -> Axis, PlotTheme -> "Detailed",
  PlotStyle -> {RGBColor[0.560181, 0.691569, 0.194885], RGBColor[0.922526, 0.385626, 0.209179]},
  PlotLabel -> "Code frequency (per week)"]
