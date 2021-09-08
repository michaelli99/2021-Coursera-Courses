#Elementary
5 + 6
1 == 2 %false
1 ~= 2 %true
1 && 0 %and
1 || 0 %or

xor(1,0) %only one true

PS1('>>>')

a = 3
a = 3; %semicolon supress result

a = pi;
a
disp(a)
disp(sprintf('2 decimals: %0.5f', a)) %display 5 decimals of a

format long
a
format short
a

#matrices manipulation
A = [1 2; 3 4; 5 6] %3x2 matrix

v = 1:0.1:2
v = 1:6

ones(2, 3)
C = 2*ones(2, 3)

zeros(2, 3)

rand(3, 3) %uniform distribution from 0 to 1
randn(1, 3) %standard normal distribution

w = -1+randn(1,100000)
hist(w)
hist(w,100)

eye(4) %I matrix

help eye

#Moving data around
A = [1 2; 3 4; 5 6]
size(A)
sz = size(A)
size(sz) %size of size is a 1x2 matrix
size(A, 1)
size(A, 2)

v = [1 2 3 4]
length(v) 
length(A) %longer dimension of the matrix will be printed
length([1;2;3;4]) %usually applied to vector

#load data
pwd %current directory (print working directory)
cd %change directory
%cd''
ls %list directory
%load xxx
%load('')

who %variables in the current scope
whos %more detailed than who

%save name.mat object;

#matrix index
A = [1 2; 3 4; 5 6]
A(3,2) %row column, answer = 6
A(2,:) %":" means every element in that row/col

A([1 3], :)

A(:, 2) = [10; 11; 12] %assign the second column of A
A = [A [100; 101; 102]] %append another column to right
A(:) %put all elements of A into a single vector

A = [1 2; 3 4; 5 6]
B = [11 12; 13 14; 15 16]
C = [A B]
C = [A; B]

#computing on data
A .* B %elementwise product
A .^2 %elementwise square
1 ./A %elementwise inverse

A+1
A + ones(3,2)

A' %transpose

B = [1 2 3 0]
val1 = max(B)
[val1, ind1] = max(B) %find the max value and index of B

val = max(A)

B < 3
find(B < 3) %return the index that make it true

A = magic(3) %all rows and columns add up to the same 

sum(A) %add elements together
prod(A) %time together
floor(A) %rounded down
ceil(A) %rounded up

A = magic(3)
B = rand(3,3)
max(A, B)

max(A, [], 1) %1 means by column, 2 means by row

B
sum(B, 1)
sum(B, 2)

flipud(eye(10))




