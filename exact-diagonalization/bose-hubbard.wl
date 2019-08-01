(* ::Package:: *)

(* ::Chapter:: *)
(*Exact diagonalization: Bose\[Dash]Hubbard model*)


(* ::Text:: *)
(*See https://arxiv.org/abs/1102.4006.*)


(* ::Section:: *)
(*Functions*)


Remove["Global`*"]


flattenFirst = (Flatten[#, 1] &);


(* `siteNum`: M in the paper
 * `particleNum`: N in the paper
 *)
getBasis[siteNum_, particleNum_] :=
  ReverseSort @ flattenFirst[
    Permutations[PadRight[#, siteNum]] & /@ IntegerPartitions[particleNum, siteNum]]


(* `basis`: a list of vectors, generated by `getBasis[]`
 * `couplingConst`: U / J
 *)
getMatrix[basis_, couplingConst_] := With[{basisNumRange = Range @ Length @ basis},
  SparseArray @ Join[
    kineticPart[basis, AssociationThread[basis -> basisNumRange], basisNumRange],
    interactionPart[basis, couplingConst, basisNumRange]]]

kineticPart[basis_, positionMap_, basisNumRange_] :=
  flattenFirst @ MapThread[kineticPartMapFunc] @ {
    Apply[{positionMap[#1], #2} &, DeleteCases[{_, 0.}] /@
      Transpose[{operatorADaggerAState[basis], operatorADaggerAValue[basis]}, {3, 1, 2}], {2}],
    basisNumRange}
operatorADaggerAState[basis_] := With[{len = Length @ First @ basis},
  Outer[Plus, basis, #, 1] & @
    flattenFirst[NestList[RotateRight, PadRight[#, len], len - 1] & /@ {{1, -1}, {-1, 1}}]]
operatorADaggerAValue[basis_] :=
  -Sqrt[(#1 + 1.) * #2] & @@@ (Join[#, Reverse[#, {2}]] & @ Partition[#, 2, 1, 1]) & /@ basis
kineticPartMapFunc[stateValuePairs_, index_] :=
  ({index, #1} -> #2) & @@@ stateValuePairs

interactionPart[basis_, couplingConst_, basisNumRange_] :=
  MapThread[{#1, #1} -> #2 &,
    {basisNumRange, 0.5 * couplingConst * Sum[i * (i - 1), {i, #}] & /@ basis}]


(* The original MATLAB code uses `eigs(H,2,'sa')`, where `'sa'` means `'smallestreal'`. *)
getEigensystem[matrix_, num_: 1] :=
  -Eigensystem[N[-matrix], num, Method -> {"Arnoldi", "Criteria" -> "RealPart"}]
getGroundEigensystem[matrix_] :=
  First /@ getEigensystem[matrix, 1]


(* SPDM = single-particle density matrix.
 * For the diagonal elements, it should be evaluated as
 *   (groundState * groundState) . basis[[All, i]]
 * But it happens to be simply 1.
 *)
getSPDM[groundState_, basis_, {i_, i_}] := 1.
getSPDM[groundState_, basis_, {i_, j_}] :=
  Total @ Merge[AssociationThread /@ {
      basis -> groundState,
      (basis + ConstantArray[ReplacePart[
          ConstantArray[0, Length @ First @ basis], {i -> 1, j -> -1}], Length @ basis])
        -> (Sqrt[(#[[i]] + 1.) * #[[j]]] & /@ basis) * groundState
    }, getSPDMMergeFunc]
getSPDMMergeFunc[{a_}] := 0.
getSPDMMergeFunc[{a_, b_}] := a * b


(* We can simplify the calculation with the help of symmetry:
 *   - rho[i, j] = rho[j, i]
 *   - rho[i, j] = rho[i+1, j+1]
 *   - Periodic boundary condition, so the 1st row is as
 *       1, a, b, ..., y, z, (z), y, ..., b, a
 *     The `(z)` is dependent on whether `siteNum` is odd or even.
 *)
getCondensateFraction[groundState_, basis_, siteNum_, particleNum_] := With[{
    eval = Table[getSPDM[groundState, basis, {1, i}], {i, 2, Ceiling[(siteNum + 1) / 2]}]},
  First[Eigenvalues[#, 1]] / particleNum & @
    NestList[RotateRight, Join[{1.}, eval, Reverse[eval][[2 - Mod[siteNum, 2] ;;]]], siteNum - 1]]


getOccupationVariance[groundState_, basis_, i_: 1] := With[{
    groundStateSquared = groundState * groundState, basisAtI = basis[[All, i]]},
  Sqrt[groundStateSquared . (basisAtI * basisAtI) - (groundStateSquared . basisAtI)^2]]


(* ::Section:: *)
(*Test*)


(* The length sequence of `getBasis[n, n]` is https://oeis.org/A001700. *)
Echo @ AbsoluteTiming[Length[getBasis[#, #]] & /@ Range[10]];


n = 3;
k = 1.;
Echo @ First @ AbsoluteTiming[basis = getBasis[n, n]];
Echo @ First @ AbsoluteTiming[matrix = getMatrix[basis, k]];
Echo @ First @ AbsoluteTiming[eigen = getGroundEigensystem[matrix]];
groundState = Last @ eigen;
Echo @ First @ AbsoluteTiming[spdm = getSPDM[groundState, basis, {1, Ceiling[n / 2]}]];
Echo @ First @ AbsoluteTiming[cf = getCondensateFraction[groundState, basis, n, n]];
Echo @ First @ AbsoluteTiming[ov = getOccupationVariance[groundState, basis]];
Echo[Length @ basis, "basis len: "];
Echo[MatrixPlot[matrix, PlotLegends -> Automatic, ImageSize -> Medium], "matrix: "];
Echo[eigen // Short, "eigen-system: "];
Echo[spdm, "SPDM: "];
Echo[cf, "condensate fraction: "];
Echo[ov, "occupation variance: "];


nRange = Range[3, 5];
kRange = Subdivide[20., 32];
test[n_] := Module[{basis, matrix, groundState},
  basis = getBasis[n, n];
  matrix = ParallelMap[getMatrix[basis, #] &, kRange];
  groundState = Last /@ getGroundEigensystem /@ matrix;
  ParallelMap[<|
    "spdm" -> getSPDM[#, basis, {1, Ceiling[n / 2]}],
    "cf" -> getCondensateFraction[#, basis, n, n],
    "ov" -> getOccupationVariance[#, basis]
  |> &, groundState]]

result = {};
Echo[AbsoluteTiming[AppendTo[result, test @ #];], "N = " <> ToString @ # <> ": "] & /@ nRange;
result = Merge[Flatten] /@ result;
result = With[{keys = Keys @ First @ result},
  AssociationThread[keys -> Outer[Transpose @ {kRange, #2[#1]} &, keys, result]]];

plotFunc[key_, label_, opts: OptionsPattern[]] :=
  ListLinePlot[result[key],
    PlotRange -> {-0.06, 1.06},
    PlotTheme -> "Detailed",
    ImageSize -> 300,
    PlotLabel -> label,
    FilterRules[{opts}, Options[ListLinePlot]]]
Row[{
  plotFunc["spdm", "SPDM"],
  plotFunc["cf", "Condensate fraction"],
  plotFunc["ov", "Occupation variance", PlotLegends -> nRange]}]
