(* ::Package:: *)

(* ::Title:: *)
(*Project Euler (61\[Dash]70)*)


(* ::Section:: *)
(*61. Cyclical figurate numbers*)


polygonalNumberSolve[r_] :=
  n /. Solve[1000 <= PolygonalNumber[r, n] < 10000, n, PositiveIntegers]
polygonalNumbers = Association @@ Table[
  r -> QuotientRemainder[#, 100] & @ Select[Mod[#, 100] >= 10 &] @
    PolygonalNumber[r, polygonalNumberSolve[r]],
  {r, 3, 8}
];


pythonCode = "
def back_track(nums: dict[int, list[tuple[int, int]]], s: list[tuple[int, int]]):
    if not nums:
        return True

    prev_j = s[-1][1]

    for r, tuples in nums.items():
        for i, j in filter(lambda t: t[0] == prev_j, tuples):
            temp_nums = nums.copy()
            temp_nums.pop(r)
            temp_res = s.copy()
            s.append((i, j))
            if back_track(temp_nums, s):
                if s[0][0] == s[-1][1]:
                    res = [x * 100 + y for (x, y) in s]
                    print(res)
                    print(sum(res))
            s = temp_res
    return False

POLYGONAL_NUMBERS = <* polygonalNumbers *>

r0 = next(iter(POLYGONAL_NUMBERS))
for i, j in POLYGONAL_NUMBERS[r0]:
    numbers = POLYGONAL_NUMBERS.copy()
    numbers.pop(r0)
    back_track(numbers, s=[(i, j)])
";
ExternalEvaluate["Python", pythonCode]
(* [8256, 5625, 2512, 1281, 8128, 2882] *)
(* 28684 *)


(* ::Section:: *)
(*62. Cubic permutations*)


Min @ Values @ Select[Length[#] == 5 &] @
  GroupBy[Range[10000]^3, Sort @* IntegerDigits]
(* 127035954683 *)


(* ::Section:: *)
(*63. Powerful digit counts*)


n /. Solve[10^(1 - 1/n) == 9, n, Reals] // Simplify // First // N
(* 21.8543 *)


Count[_?(Apply[IntegerLength[#3] == #2 &])] @
  Catenate @ Outer[{#1, #2, #1^#2} &, Range[9], Range[21]]
(* 49 *)


(* ::Section:: *)
(*64. Odd period square roots*)


Count[{_, _?(OddQ @ Length @ # &)}] @ ContinuedFraction @ Sqrt[Range[10000]]
(* 1322 *)


(* ::Section:: *)
(*65. Convergents of e*)


Total @ IntegerDigits @ Numerator @
  FromContinuedFraction @ ContinuedFraction[E, 100]
(* 272 *)


(* ::Section:: *)
(*66. Diophantine equation*)


solve[d_] := x /. First @
  FindInstance[x^2 - d * y^2 == 1, {x, y}, PositiveIntegers]
range = Complement[Range[#], Range[Sqrt @ #]^2] & @ 1000;
MaximalBy[ParallelTable[{d, solve[d]}, {d, range}], Last][[1, 1]]
(* 661 *)


(* ::Section:: *)
(*67. Maximum path sum II*)


maxPathSum @
  Import["https://projecteuler.net/project/resources/p067_triangle.txt", "Table"]
(* 7273 *)


(* ::Section:: *)
(*68. Magic 5-gon ring*)


nGonRing[n_] := Module[
  {canonicalPerm, inners, armSum, fill, isValid, toDigits},
  canonicalPerm[p_] := RotateLeft[p, #] & /@ Range[n] // Sort;
  inners = DeleteDuplicatesBy[canonicalPerm] @
    Permutations[Range[2n], {n}];
  armSum[inner_] := Total[inner] / n + 2n + 1;
  fill[inner_] := With[{list = Partition[inner, 2, 1, 1]},
    Reverse /@ MapThread[Append, {list, armSum[inner] - Total /@ list}]];
  isValid[ring_] := With[{list = Flatten[ring]},
    Length @ Union @ list == 2n && AllTrue[Positive[#] && IntegerQ[#] &] @ list];
  toDigits[ring_] := FromDigits @ Flatten @ IntegerDigits @ MinimalBy[
    RotateLeft[Reverse[ring], #] & /@ Range[n], #[[1, 1]] &];
  toDigits /@ Select[fill /@ inners, isValid]
]
Max @ nGonRing[3]
(*Max @ Select[# < 1*^16 &] @ nGonRing[5]*)
(* 6531031914842725 *)


(* ::Section:: *)
(*69. Totient maximum*)


First @ MaximalBy[Range[1*^6], # / EulerPhi[#] &]
(* 510510 *)


(* ::Section:: *)
(*70. Totient permutation*)


#[[1, 1]] & @ MinimalBy[Apply[Divide]] @
  Select[Equal @@ Sort /@ IntegerDigits[#] &] @
    Table[{n, EulerPhi[n]}, {n, 2, 1*^7}] // AbsoluteTiming
(* {83.527159, 8319823} *)
