function binary = oct2bin(octal,bin_len)  
% oct2bin(octal,binary_length) returns the binary representation  
% of the octal input number, where binary_length is the desired  
% number of binary digits to be output.  
%  
%  
bin_len=7;%added for Gpoly[133 171] JC 7/21/08 (bin_len=8 may be more correct)  
binary = zeros(1,bin_len+2);  
i = 1;  
oct = octal;  
while (oct > 0)  
if oct > 9  
oct_digit = rem(oct,10);  
else  
oct_digit = oct;  
end  
  for k = 1:3  
binary(i) = rem(oct_digit,2);  
oct_digit = floor(oct_digit/2);  
i = i+1;  
  end  
    oct = fix(oct/10);  
end  
binary = binary(1,bin_len:-1:1);  
 
