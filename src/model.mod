set P = {1..3};
set S = {1, 2};
set D = {1..3};
set K = {1, 2};
set Y = {1..4};
set U = {1, 2};

param T := 3;

var p {P} >= 0 integer;
var s {S} integer;
var s1 {1..T} >= 0 integer;
var s2 {1..T} >= 0 integer;
var d {D} >= 0 integer;
var dk {2..3} >= 0 integer;
var dp {D, P} >= 0 integer;
var k {K} >= 0 integer;
var kp {K, P} >= 0 integer;


# flaga uwodorowienia
var w binary;

# flaga progów wykorzystania surowca S1
var u {S, U} binary;

# parametry MPO
param lambda {Y};
param a {Y};
param beta := 0.001;
param eps := 0.0001/4;

# zmienne MPO
var v;
var z {i in Y};
var y {i in Y};

# funkcja celu dla MPO
maximize goal: v + eps*(sum {i in Y} y[i]);

#ograniczenia MPO
subject to 
    mpo_1 {i in Y} :  v <= z[i];
    mpo_2 {i in Y} :  z[i] <= lambda[i]*beta*(y[i] - a[i]);
    mpo_3 {i in Y} :  z[i] <= lambda[i]*(y[i] - a[i]);

var inc = 176*p[1] + 140*p[2] + 109*p[3] - y[1];

# ograniczenia
subject to 
    o_1a: s[1] <= 9000;
    o_1b: s[2] <= 12000;

subject to     
    o_2: d[1] + d[2] +d[3] <= 14722;

subject to
    o_3a:  d[1]= 0.2*s[1] + 0.1*s[2];
    o_3b:  d[2]= 0.5*s[1] + 0.7*s[2];
    o_3c:  d[3] = 0.3*s[1] + 0.2*s[2];

subject to
    o_4:  k[1] + k[2] <= 5454;

subject to
    o_5 {i in 2..3}: d[i] = dp[i, 2] + dk[i];

subject to
    o_6a: k[1] = 0.1*dk[2] + 0.4*dk[3];
    o_6b: k[2] = 0.9*dk[2] + 0.6*dk[3];

subject to
    o_7: p[1] = dp[1, 1] + kp[1, 1] + kp[2, 1];
    o_8: p[2] = dp[2, 2] + dp[3, 2] + kp[1, 2] + kp[2, 2];
    o_9: p[3] = dp[1, 3];
    o_10: d[1] = dp[1, 1] + dp[1, 3];
    o_11_12 {i in K}: k[i] = kp[i, 1] + kp[i, 2];

subject to
    o_14a: (k[1] + k[2]) <= 5454*w;
    o_14b: (k[1] + k[2]) >= 0;

subject to
    o_15a: s[1] = sum {i in 1..T} s1[i];
    o_15b_1: 1860*u[1,1] <= s1[1] ;
    o_15b_2: s1[1] <= 1860;
    o_15c_1: (5398-1860)*u[1,2] <=  s1[2];
    o_15c_2: s1[2] <= (5398-1860)*u[1,1];
    o_15d_1: 0 <= s1[3];
    o_15d_2: s1[3] <= (9000-5398)*u[1,2];

subject to
    o_16a: s[2] = sum {i in 1..T} s2[i];
    o_16b_1: 3694*u[2,1] <= s2[1] ;
    o_16b_2: s2[1] <= 3694;
    o_16c_1: (8013 - 3694)*u[2,2] <=  s2[2];
    o_16c_2: s2[2] <= (8013 - 3694)*u[2,1];
    o_16d_1: 0 <= s2[3];
    o_16d_2: s2[3] <= (12000 - 8013)*u[2,2];

subject to
    total_cost: y[1] = 13000*w + 12*s1[1] + 8*s1[2] + 5*s1[3] + 12*s2[1] + 16*s2[2]  + 21*s2[3] + 140*s[1] + 110*s[2];
    deficits {i in P}: y[i + 1] = 1 - (p[i]/3495);
    total_cost_lb {i in P}: y[1]  >= 0;

