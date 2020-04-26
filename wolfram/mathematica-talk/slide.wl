(* ::Package:: *)


(* ::Title:: *)
(*\[MathematicaIcon] Mathematica in a Nutshell*)


(* ::Author:: *)
(*Xiangdong Zeng*)


(* ::Affiliation:: *)
(*Department of Physics, Fudan University*)


(* ::Section:: *)
(*Install*)


(* ::Item:: *)
(*\[Yen]600 in Taobao*)


(* ::Item:: *)
(*https://tiebamma.github.io/InstallTutorial/*)


(* ::Section:: *)
(*\[KernelIcon] An advanced calculator*)


(* ::Text:: *)
(*Use Python if you don’t like it (Use > at the beginning of a line):*)


(* ::ExternalLanguage:: *)
(*[i for i in range(0, 30) if i % 5 == 0]*)


(* ::ExternalLanguage:: *)
(*import matplotlib.pyplot as plt*)
(*import numpy as np*)
(**)
(*data = {'a': np.arange(50),*)
(*        'c': np.random.randint(0, 50, 50),*)
(*        'd': np.random.randn(50)}*)
(*data['b'] = data['a'] + 10 * np.random.randn(50)*)
(*data['d'] = np.abs(data['d']) * 100*)
(**)
(*plt.scatter('a', 'b', c='c', s='d', data=data)*)
(*plt.xlabel('entry a')*)
(*plt.ylabel('entry b')*)
(*plt.show()*)


(* ::Subsection:: *)
(*Wolfram|Alpha*)


(* ::WolframAlphaLong:: *)
(*integrate 1/(sqrt sin x) dx from 0 to pi*)


(* ::WolframAlphaLong:: *)
(*plot 1/(sqrt sin x) from 0 to 2pi*)


(* ::Subsection:: *)
(*Syntax*)


(* ::Item:: *)
(*Do whatever in your notebook (aka. 2D typesetting)*)


(* ::Item:: *)
(*Built-in functions start with a CAPITAL letter*)


(* ::Item:: *)
(*Brackets*)


(* ::Subitem:: *)
(*[...] for function call*)


(* ::Subitem:: *)
(*[[...]] for array/list index*)


(* ::Subitem:: *)
(*{...} for list*)


(* ::Subitem:: *)
(*(...) as in mathematics*)


(* ::Subitem:: *)
(*(* comment *)*)


(* ::Item:: *)
(*Shift+Enter to run; Enter for new line*)


(* ::Item:: *)
(*F1 to find help*)


(* ::Item:: *)
(*Use semicolon (;) to hide output*)


(* ::Subsection:: *)
(*Arithmetic, calculus & algebra*)


(* ::Item:: *)
(*Most useful function: Simplify[] & FullSimplify[]*)


(* ::Item:: *)
(*Expand[], Factor[], TrigExpand[], ...*)


(* ::Item:: *)
(*Solve[] & Reduce[]*)


(* ::Item:: *)
(*Derivative: D[] & Dt[]*)


(* ::Item:: *)
(*Integral: Integrate[]*)


(* ::Subitem:: *)
(*Esc+int+Esc for \[Integral]*)


(* ::Subitem:: *)
(*Esc+dd+Esc for \[DifferentialD]*)


(* ::Item:: *)
(*Differential equations: DSolve[]*)


(* ::Item:: *)
(*FourierTransform[]*)


(* ::Item:: *)
(*Try to use build-in functions (do NOT reinvent the wheel)*)


(* ::Subsection:: *)
(*Numeric algorithms*)


(* ::Item:: *)
(*Exact and numeric things are totally different!*)


(* ::Item:: *)
(*N[]*)


(* ::Item:: *)
(*NSolve[], FindRoot[] & NDSolve[]*)


(* ::Subsection:: *)
(*Save you from physics experiments*)


(* ::Item:: *)
(*Quantity[]*)


(* ::Item:: *)
(*UnitConvert[]*)


(* ::Item:: *)
(*Around[]*)


(* ::Subsection:: *)
(*Visualization*)


(* ::Item:: *)
(*For expression: Plot[], Plot3D[], LogPlot[], ...*)


(* ::Item:: *)
(*For list of data: ListPlot[], ListPlot3D[], ListLogPlot[], ...*)


(* ::Item:: *)
(*Add a time axis: Manipulate[]*)


(* ::Item:: *)
(*Export[]*)


(* ::Section:: *)
(*\[Wolf] The language itself*)


(* ::Item:: *)
(*.nb vs .wl/.wls*)


(* ::Item:: *)
(*You may try other editor (e.g. VS Code)*)


(* ::Subsection:: *)
(*Data structure (1): List*)


(* ::Subsubsection:: *)
(*Basic*)


(* ::Item:: *)
(*{1,2,3,...} or List[1,2,3,...]*)


(* ::Item:: *)
(*Index begin with 1*)


(* ::Item:: *)
(*Use -1 to access the last item*)


(* ::Item:: *)
(*So, what is index 0?*)


(* ::Subsubsection:: *)
(*Structure of expression*)


(* ::Item:: *)
(*list\[LeftDoubleBracket]0\[RightDoubleBracket] gives the “Head”: List*)


(* ::Item:: *)
(*So called S-expression: Construct[]*)


(* ::Item:: *)
(*Meta-programming: “code is data structure”*)


(* ::Subsubsection:: *)
(*Use list more efficiently*)


(* ::Item:: *)
(*Loop over a list:*)


(* ::Subitem:: *)
(*Avoid using For[]*)


(* ::Subitem:: *)
(*Map[] (/@)*)


(* ::Subitem:: *)
(*Use built-in functions*)


(* ::Item:: *)
(*Thinking mathematically:*)


(* ::Subitem:: *)
(*Inner & outer product*)


(* ::Subitem:: *)
(*Transpose[]*)


(* ::Subitem:: *)
(*Union[], RotateLeft[], ...*)


(* ::Subsection:: *)
(*Data structure (2): Association*)


(* ::Item:: *)
(*Require version 10.0+*)


(* ::Item:: *)
(*Key-value list*)


(* ::Item:: *)
(*Like dict in Python, std::map in C++*)


(* ::Item:: *)
(*Map[] vs KeyMap[]*)


(* ::Item:: *)
(*Some kind of OOP*)


(* ::Subsection:: *)
(*Functional programming*)


(* ::Subsubsection:: *)
(*Explore Map[]*)


(* ::Item:: *)
(*What’s the first arguments of Map[]?*)


(* ::Item:: *)
(*A “pure function”*)


(* ::Subitem:: *)
(*f: X \[Rule] Y, x \[Function] f(x)*)


(* ::Subitem:: *)
(*Lambda expression: \[Lambda] x . x*)


(* ::Item:: *)
(*A function actually has only one argument: Curry[]*)


(* ::Subitem:: *)
(*F(x, y) = (f(x)) (y)*)


(* ::Subitem:: *)
(*F: \[DoubleStruckCapitalR] * \[DoubleStruckCapitalZ] \[Rule] \[DoubleStruckCapitalC]*)


(* ::Subitem:: *)
(*f: \[DoubleStruckCapitalR] \[Rule] C(\[DoubleStruckCapitalZ], \[DoubleStruckCapitalC])*)


(* ::Subitem:: *)
(*f(x): \[DoubleStruckCapitalZ] \[Rule] \[DoubleStruckCapitalC]*)


(* ::Subsubsection:: *)
(*Basic category theory*)


(* ::Item:: *)
(*Category (type): set, group, Integer*)


(* ::Subitem:: *)
(*Object: element in a category*)


(* ::Item:: *)
(*Morphism (function): “function”, group homomorphism, (#+1)&*)


(* ::Subitem:: *)
(*Object \[Rule] object*)


(* ::Subitem:: *)
(*Axioms: associativity & identity*)


(* ::Item:: *)
(*Functor: structure-preserving maps between categories*)


(* ::Subitem:: *)
(*Object x in C \[Implies] object F(x) in D*)


(* ::Subitem:: *)
(*Morphism f: x \[Rule] y over C \[Implies] morphism F(f): F(x) \[Rule] F(y) over D*)


(* ::Subitem:: *)
(*E.g. Map: f (a function over Integer) \[Implies] Map[f] (a function over List[Integer])*)


(* ::Subsubsection:: *)
(*Other higher-order functions*)


(* ::Item:: *)
(*Apply[] (@@): replace head*)


(* ::Item:: *)
(*Nest[], NestWhile[] & FixedPoint[]*)


(*
  Newton’s method:
  * (# + 2 / #) / 2 &: iteration function
  * 1.0: initial value
  * UnsameQ: condition to end iteration
  * 2: UnsameQ needs two arguments
*)
NestWhile[(# + 2 / #) / 2 &, 0.01, UnsameQ, 2]


(* ::Item:: *)
(*Parallelization: Map[] \[Rule] ParallelMap[]*)


(* ::Subsection:: *)
(*Pattern matching*)


(* ::Subsubsection:: *)
(*Demo*)


qSort[{}] := {}
qSort[{x_, xs___}] := Join @@
  {qSort @ Select[{xs}, # \[LessEqual] x &], {x}, qSort @ Select[{xs}, # > x &]}
Echo /@ {#, qSort[#]} & @ RandomInteger[{0, 100}, 30];


checkboard = RandomInteger[1, {40, 100}];
update[1, 2] := 1; update[_, 3] := 1; update[_, _] := 0;
SetAttributes[update, Listable];
Dynamic[ArrayPlot[
  checkboard = update[
    checkboard,
    Plus @@ Map[
      RotateRight[checkboard, #]&,
      {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}]
    ]
  ]]


(* ::Subsubsection:: *)
(*Patterns*)


(* ::Item:: *)
(*Basic*)


(* ::Subitem:: *)
(*_: any expression*)


(* ::Subitem:: *)
(*__: 1+ expressions*)


(* ::Subitem:: *)
(*___: 0+ expression(s)*)


(* ::Subitem:: *)
(*x_: name it as x for latter use*)


(* ::Item:: *)
(*Restrictions*)


(* ::Subitem:: *)
(*_h: only match expr with Head h*)


(* ::Subitem:: *)
(*_?p: only match expr when p gives True*)


(* ::Item:: *)
(*“Function definition”*)


(* ::Subitem:: *)
(*f[x_] := ...*)


(* ::Subitem:: *)
(*Set[] (=) vs SetDelayed[] (:=)*)


(* ::Subsubsection:: *)
(*Rules*)


(* ::Item:: *)
(*Rule[] (\[Rule]) vs RuleDelayed[] (\[RuleDelayed])*)


(* ::Item:: *)
(*Results of Solve[] & DSolve[] are rules*)


(* ::Subsection:: *)
(*Debug*)


(* ::Item:: *)
(*Print[] & Echo[]*)


(* ::Item:: *)
(*Timing[] & AbsoluteTiming[]*)


(* ::Item:: *)
(*Write small functions for easier debugging*)


(* ::Section:: *)
(*\[LightBulb] Example: COVID-19 in the US*)
