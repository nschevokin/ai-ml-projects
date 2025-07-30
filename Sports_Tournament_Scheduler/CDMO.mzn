include "globals.mzn";
% params
int: number; 
set of int: Teams = 1..number; 
int: weeks = number - 1; 
int: periods = number div 2; 
% set of unique combinations of 2 different teams, where the order is bidirectional 
% it can be thought of as the binomial coefficient 2 out of number we furnish. Hence it gives n(n-1)/2
int: m = number * (number - 1) div 2; 
% to impose "every pair appears precisely once", we use all_different which processes only 1D integer vectors 
% triangular matrix hence (n-1) pairs in row 1, (n-2) on row 2, ..., n-(i-1) in row i-1. 
% summing gives (i-1)n - (i-1)i/2 
array[1..weeks, 1..periods] of var 1..m  : matrix_of_dist_pairs; 

% decision domain 

% scheduled home in week w, period p 
array[1..weeks, 1..periods] of var Teams: home; 
array[1..weeks, 1..periods] of var Teams: away; 

% frequency of each team per period p 
array[Teams, 1..periods] of var 0..weeks: period_counter; 

% CONSTRAINT 1 (every team plays with every other team only once) 
% Orientation removes (j,i) duplicates 
constraint forall(w in 1..weeks, p in 1..periods)( home[w,p] < away[w,p]); 

% as per the sum let's assume i = home[w,p] (rows of the matrix) 
% (away[w,p] - home[w,p]) is the distance from the leftmost pair of the row to the target one. this offset is of need to impose one-to-one mapping 
constraint forall(w in 1..weeks, p in 1..periods)(matrix_of_dist_pairs[w,p] = (home[w,p] - 1) * number - ((home[w,p] - 1) * home[w,p]) div 2 + (away[w,p] - home[w,p])) /\ all_different([matrix_of_dist_pairs[w,p] | w in 1..weeks, p in 1..periods]); 

% CONSTRAINT 2 (every team plays once a week) 
array[Teams] of int: ones = [1 | _ in Teams]; 
constraint forall(w in 1..weeks)(global_cardinality([home[w,p] | p in 1..periods] ++ [away[w,p] | p in 1..periods], Teams, ones));

% CONSTRAINT 3 (every team plays at most twice in the same period over the tournament)
constraint if number >= 6 then 
    forall(t in Teams, p in 1..periods)(period_counter[t,p] <= 2) else true endif 
/\ forall(p in 1..periods)(global_cardinality([home[w,p] | w in 1..weeks] ++ [away[w,p] | w in 1..weeks], [t | t in Teams], [period_counter[t,p] | t in Teams]));

% SYMMETRY BREAKING 1 (fixing how many times team 1 is assigned to each period over the whole season) 
int: full = weeks div periods; 
int: extra = weeks mod periods; 
constraint forall(p in 1..extra)(period_counter[1,p] = full + 1) /\ forall(p in extra + 1..periods)(period_counter[1,p] = full); 

% SYMMETRY BREAKING 2 (1 plays w+1 at home in a rotating slot) 
% rotating_p is the period index that rotates as the weeks advance 
constraint forall(w in 1..weeks)(let { int: rotating_p = ((w-1) mod periods) + 1} in home[w,rotating_p] = 1 /\ away[w,rotating_p] = w + 1)
/\ forall(w in 1..weeks, q in 1..periods where q != ((w-1) mod periods) + 1)(home[w,q] != 1 /\ away[w,q] != 1); 

% SYMMERY BREAKING 3 (home ≠ away)
constraint forall(w in 1..weeks, p in 1..periods)(home[w,p] != away[w,p]);

% Search strategy 
array[int] of var int: flat_home = [home[w,p] | w in 1..weeks, p in 1..periods];
array[int] of var int: flat_away = [away[w,p] | w in 1..weeks, p in 1..periods];

solve
  :: int_search(flat_home, first_fail, indomain_min, complete)
  :: int_search(flat_away, first_fail, indomain_min, complete)
  satisfy;


output
[
  "Schedule\n"
] ++
[
  "Week " ++ show(w) ++ ":\n" ++
  concat([ "  Period " ++ show(p) ++ ": "
           ++ show(home[w,p]) ++ " vs " ++ show(away[w,p]) ++ "\n"
         | p in 1..periods ])
  | w in 1..weeks
] ++
[
  "----------\n###JSON###\n",
  "{ \"home\":", show(flat_home), ", \"away\":", show(flat_away), " }\n"
];





