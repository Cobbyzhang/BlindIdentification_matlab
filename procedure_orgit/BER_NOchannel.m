% simmulation of convolutional encoding / Viterbi decoding

clear
clc
codeselect=4;

switch codeselect
    case 1
        Gpoly=[5 7];
    case 2
        Gpoly=[6 2 6; 2 4 4];
    case 3
        Gpoly=[4 2 6; 1 4 7];
    case 4
        Gpoly=[60 30 70; 14 40 74];
end

%===============================================================
% Find key descriptors of the convolutional code
%===============================================================
display_info=1;
[K, M, nu, n, k, coderate, StateTable]=getcodeparameters(Gpoly);
% StateTable
%===============================================================
% Generate Data
%===============================================================
NoBits=1000; % How many bit are to be sent
              % Note: long sequneces take a lot of memory 
              % resulting in long decoding times
m=floor(rand(1,NoBits).*2); % generate data bits

%===============================================================
% Prepare data by adding leading/trailing zeros to start/end in the zero
% state
%===============================================================
% first add k*nu leading zeros to start from 0 state
m2=[zeros(1,k.*nu) m zeros(1,k.*nu)];
NoOfLeadingAddedZeros=k.*nu;
% add extra zeros to make m a multiple of k
if rem(length(m2),k) > 0 % length(m) must be a multiple of k 
                        % No of input bits to encoder
  ExtraZeros=zeros(size(1:k-rem(length(m),k)));                          
  NoOfExtraZeros=length(ExtraZeros);
  m2=[m2 ExtraZeros]; % add the zeros
  NoOFTrailingAddedZeros=k.*nu+NoOfExtraZeros;
else
  NoOFTrailingAddedZeros=k.*nu;  
end
%===============================================================
% Encode Data Using Covolutional encoder
%===============================================================
[c,c_bin,PathThroughTrellis]=encoder(m2,k,n,StateTable);
%[c,c_bin]=CVencode(m,k,n,StateTable); %If PathThroughTrellis isn't needed
%===============================================================
% simulate Channel
%===============================================================
r=c_bin; % for binary channel
%===============================================================
% Hard Decision VA
%===============================================================
[m2_est,c_bin_est,CumulatedMetric ]=decoder(r, StateTable, M, k , n);
%remove trailing/leading zeros
m_est=m2_est;
m_est(1:NoOfLeadingAddedZeros)=[];
m_est(end- NoOFTrailingAddedZeros+1:end)=[];
BER=length(find(m_est~=m))./length(m_est)

