clc
clear
%% ºòÑ¡±àÂëÆ÷g
% g1
vCard{1} = [2,3];
GCard{1} = poly2trellis(vCard{1},[3 1 2;4 7 1]);
TGCard{1} =poly2trellis(vCard{1},[3 1 2;1 4 7]);
nCard{1} = 3;
kCard{1} = 2;
tCard{1} = [1 0;3 1];
%{
G(D) = 
  +-                                    -+ 
  |                                      | 
  |   x + 1 ,        x       ,      1    | 
  |                                      | 
  |               2                  2   | 
  |      1  ,    x  + x + 1  ,      x    | 
  +-                                    -+
%}
%{
T(D)G(D) = 
  +-                                    -+ 
  |                                      | 
  |   x + 1 ,       x      ,      1      | 
  |                                      | 
  |      2                     2         | 
  |     x   ,       1      ,  x  + x + 1 | 
  +-                                    -+
%}

%g2
vCard{2} = [3,3];
GCard{2} = poly2trellis(vCard{2},[4 6 1;5 1 2]);
TGCard{2} =poly2trellis(vCard{2},[1 7 3;4 6 1]);
nCard{2} = 3;
kCard{2} = 2;
tCard{2} = [1 1;1 0];

%g3
vCard{3} = [4,4,4];
GCard{3} = poly2trellis(vCard{3},[15 06 10 11;04 16 11 13;14 01 12 16]);
%TGCard{3} =poly2trellis(vCard{3},[10 17 03 05;11 10 01 02;05 11 13 14]);
nCard{3} = 4;
kCard{3} = 3;
tCard{3} = [0 1 1;1 1 0;1 1 1];
T3 = num2symmat(tCard{3});
GD3 = poly2symmat(vCard{3},[15 06 10 11;04 16 11 13;14 01 12 16]);
[v3_test,poly3_test] = symmat2poly(mod(T3*GD3,2));
TGCard{3} = poly2trellis(v3_test,poly3_test);
%{
G(D) = 
  +-                                                      -+ 
  |    3                2                         3        | 
  |   x + x + 1 ,      x +  x      ,    1     ,  x + 1     | 
  |                                                        | 
  |                   2                3          3   2    | 
  |      x      ,    x  + x + 1    ,  x  + 1  ,  x + x + 1 | 
  |                       3            2          2        | 
  |     x + 1   ,        x         ,  x + 1   ,  x + x + 1 | 
  +-                                                      -+
%}

%g4

vCard{4} = [3,6,6];
GCard{4} = poly2trellis(vCard{4},[4 6 1 5 2;01 32 43 60 04;24 61 42 70 41]);
nCard{4} = 5;
kCard{4} = 3;
tCard{4} = [1 0 0;11 0 1;12 1 1];
T4 = num2symmat(tCard{4});
GD4 = poly2symmat(vCard{4},[4 6 1 5 2;01 32 43 60 04;24 61 42 70 41]);
[v4_test,poly4_test] = symmat2poly(mod(T4*GD4,2));
%gt4 = poly2trellis(v4_test,poly4_test);
TGCard{4} =poly2trellis(v4_test,poly4_test);
%gt4 = poly2trellis(v4,[4 6 1 5 2;40 37 57 01 73;31 41 02 07 43]);

%T4 = poly2symmat([1 1 1],[1 0 0;0 1 0;1 1 1]);
%GDT4 = poly2symmat(v4,[4 6 1 5 2;40 37 57 01 73;31 41 02 07 43]);
%pretty(T4)
%pretty(GD4)
%pretty(GDT4)
%{
% GD4 = 
%   +-                                                      -+ 
%   |                             2         2                | 
%   |     1,      x + 1,         x ,       x  + 1,      x    | 
%   |                                                        | 
%   |     5     4    2       5    4                     3    | 
%   |    x ,   x  + x  + x, x  + x  + 1,    x + 1,     x     | 
%   |                                                        | 
%   |   3        5              4         2           5      | 
%   |  x  + x,  x  + x + 1,    x  + 1,   x  + x + 1, x  + 1  | 
%   +-                                                      -+
%}


%g5
vCard{5} = [3,4,6,6];
GCard{5} = poly2trellis(vCard{5},[4 2 5 1 6 3 7;11 7 12 16 5 17 2;51 62 4 23 60 40 7;10 24 61 77 5 16 64]);
nCard{5} = 7;
kCard{5} = 4;
tCard{5} = [1 0 0 0;2 1 0 0;11 5 1 0;13 4 1 1];
GD5 = poly2symmat(vCard{5},[4 2 5 1 6 3 7;11 7 12 16 5 17 2;51 62 4 23 60 40 7;10 24 61 77 5 16 64]);
T5 = num2symmat(tCard{5});
[v5_test,poly5_test] = symmat2poly(mod(T5*GD5,2));
TGCard{5} = poly2trellis(v5_test,poly5_test);
%{
% GD5 =
% [             1,             x,     x^2 + 1,                           x^2,     x + 1,           x^2 + x,     x^2 + x + 1]
% [       x^3 + 1, x^3 + x^2 + x,     x^2 + 1,                   x^2 + x + 1,   x^3 + x, x^3 + x^2 + x + 1,             x^2]
% [ x^5 + x^2 + 1,   x^4 + x + 1,         x^3,                 x^5 + x^4 + x,     x + 1,                 1, x^5 + x^4 + x^3]
% [           x^2,       x^3 + x, x^5 + x + 1, x^5 + x^4 + x^3 + x^2 + x + 1, x^5 + x^3,   x^4 + x^3 + x^2,     x^3 + x + 1]

%   +-                           -+ 
%   |       1,         0,   0, 0  | 
%   |                             | 
%   |       x,         1,   0, 0  | 
%   |                             | 
%   |    3           2            | 
%   |   x  + x + 1, x  + 1, 1, 0  | 
%   |                             | 
%   |   3    2         2          | 
%   |  x  + x  + 1,   x ,   1, 1  | 
%   +-                           -+
%}

%g6
vCard{6} = [3,4];
GCard{6} = poly2trellis(vCard{6},[5 2 7;2 17 10]);
GD6 = poly2symmat(vCard{6},[5 2 7;2 17 10]);
nCard{6} = 3;
kCard{6} = 2;
tCard{6} = [1 0;3 1];
T6 = num2symmat(tCard{6});
[v6_test,poly6_test] = symmat2poly(mod(T6*GD6,2));
TGCard{6} =poly2trellis(v6_test,poly6_test);

%g7
vCard{7} = [3,5];
GCard{7} = poly2trellis(vCard{7},[5 2 7;2 35 20]);
GD7 = poly2symmat(vCard{7},[5 2 7;2 35 20]);
nCard{7} = 3;
kCard{7} = 2;
tCard{7} = [1 0;5 1];
T7 = num2symmat(tCard{7});
[v7_test,poly7_test] = symmat2poly(mod(T7*GD7,2));
TGCard{7} =poly2trellis(v7_test,poly7_test);

%g8
vCard{8} = [2,5];
GCard{8} = poly2trellis(vCard{8},[3 2 1;2 35 20]);
GD8 = poly2symmat(vCard{8},[3 4 1;2 35 20]);
nCard{8} = 3;
kCard{8} = 2;
tCard{8} = [1 0;11 1];
T8 = num2symmat(tCard{8});
[v8_test,poly8_test] = symmat2poly(mod(T8*GD8,2));
TGCard{8} =poly2trellis(v8_test,poly8_test);


%g9
vCard{9} = [4,4,6,6];
GCard{9} = poly2trellis(vCard{9},[4 2 5 11 6 3 7;11 7 12 16 5 17 2;51 62 4 23 60 40 7;10 24 61 77 5 16 64]);
nCard{9} = 7;
kCard{9} = 4;
tCard{9} = [1 0 0 0;0 1 0 0;2 0 1 0;0 2 0 1];
GD9 = poly2symmat(vCard{9},[4 2 5 11 6 3 7;11 7 12 16 5 17 2;51 62 4 23 60 40 7;10 24 61 77 5 16 64]);
T9 = num2symmat(tCard{9});
[v9_test,poly9_test] = symmat2poly(mod(T9*GD9,2));
TGCard{9} = poly2trellis(v9_test,poly9_test);


%g10
vCard{10} = [3,4,4];
GCard{10} = poly2trellis(vCard{10},[5 6 1 3;04 16 11 13;14 01 12 6]);
nCard{10} = 4;
kCard{10} = 3;
tCard{10} = [1 0 0;3 1 0;1 1 1];
GD10 = poly2symmat(vCard{10},[5 6 1 3;04 16 11 13;14 01 12 6]);
T10 = num2symmat(tCard{10});
[v10_test,poly10_test] = symmat2poly(mod(T10*GD10,2));
TGCard{10} = poly2trellis(v10_test,poly10_test);

%g11
vCard{11} = [2,4,4];
GCard{11} = poly2trellis(vCard{11},[3 2 1 2;04 16 11 13;14 01 12 16]);
nCard{11} = 4;
kCard{11} = 3;
tCard{11} = [1 0 0;5 1 0;1 1 1];
GD11 = poly2symmat(vCard{11},[3 2 1 2;04 16 11 13;14 01 12 16]);
T11 = num2symmat(tCard{11});
[v11_test,poly11_test] = symmat2poly(mod(T11*GD11,2));
TGCard{11} = poly2trellis(v11_test,poly11_test);

%g12
vCard{12} = 3;
GCard{12} = poly2trellis(vCard{12},[6 5 7]);
nCard{12} = 3;
kCard{12} = 1;
tCard{12} = 1;
TGCard{12} = poly2trellis(vCard{12},[6 5 7]);


%g13
vCard{13} = 7;
GCard{13} = poly2trellis(vCard{13},[171 131]);
nCard{13} = 2;
kCard{13} = 1;
tCard{13} = 1;
TGCard{13} = poly2trellis(vCard{13},[171 131]);


%g14
vCard{14} = 4;
GCard{14} = poly2trellis(vCard{14},[13 15 17]);
nCard{14} = 3;
kCard{14} = 1;
tCard{14} = 1;
TGCard{14} = poly2trellis(vCard{14},[13 15 17]);


%g15
vCard{15} = 5;
GCard{15} = poly2trellis(vCard{15},[25 33 37]);
nCard{15} = 3;
kCard{15} = 1;
tCard{15} = 1;
TGCard{15} = poly2trellis(vCard{15},[25 33 37]);



%% ´æ´¢
GeneratorCard.vCard = vCard;
GeneratorCard.GCard = GCard;
GeneratorCard.nCard = nCard;
GeneratorCard.kCard = kCard;
GeneratorCard.tCard = tCard;
GeneratorCard.TGCard = TGCard;

save GeneratorCard.mat GeneratorCard





