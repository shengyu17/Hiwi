SINR = 0.5; %SINR constraint
n = 3; % number of users 
m = 2; % number of base staions

sigma = 0.5; % noise


cvx_begin
variable p(m,n)

expression interference(m,n);
expression power(m);
expression h(m,n);
h= rand(m, n);
%interference = zeros(1,n);

% for every connection of basestation i and user j, calculate 
% the noise and interference
for j = 1:n
   for i = 1:m
       for k=1:m
         if(k~=i)
           interference(i,j) = interference(i,j) + p(k,j)*h(k,j);
         end
         
       end
       interference(i,j) = interference(i,j) +sigma;
   end

end

% constraints
for j=1:n
    for i = 1:m
        interference(i,j)* SINR <= h(i,j)*p(i,j);
    end
end
p>=0;

% object function
for i =1:m
   for j = 1:n
       power(i)= power(i) + p(i,j);
   end
end
minimize(sum(power))
cvx_end

