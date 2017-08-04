% simulation of convolutional encoding / Viterbi decoding
clear all;
clc
codeselect=1;
switch codeselect
    case 1
        Gpoly=[27 31];
    case 2
        Gpoly=[6 2 6; 2 4 4];
    case 3
        Gpoly=[4 2 6; 1 4 7];
    case 4
        Gpoly=[60 30 70; 14 40 74];
    otherwise
        Gpoly=[70 30 20 40; 14 50 0 54; 4 10 74 40];
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
EbNodBVals = 0:1:3;
BER=zeros(10,length(EbNodBVals));
BER2=BER;
countSNRs=0;
for Simulation=1:10,
    for SNR=1:length(EbNodBVals)
        countSNRs=countSNRs+1;
        NoOfBitErrors=0;
        TotalNoOfBits=0;
        TotalNoOfCodedBits=0;
        NoofCodedBitErrors=0;
        BERtemp=Inf;
        while NoOfBitErrors<10,
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
            %[c,c_bin]=encoder(m,k,n,StateTable); %If PathThroughTrellis isn't needed
            %===============================================================
            % simulate Channel
            %===============================================================
            % simulate BPSK modulator
            s=2.*c_bin-1;
            % noise
            EbNo=10.^(EbNodBVals(SNR)./10);
            EsNo=EbNo.*coderate;
            Es=1;
            No=Es./EsNo;
            sigma=sqrt(No.*2)./2;
            noise=sigma.*randn(size(s));
            sr=s+noise; %awgn, sr= received signal
            % hard quantize demodulator
            r=zeros(size(sr));
            r(sr>=0)=1;
            %===============================================================
            %Decode Data Using Covolutional Viterbi decoder
            %===============================================================
            [m2_est,c_bin_est,CumulatedMetric ]=decoder(r, StateTable, M, k , n);
            %remove trailing/leading zeros
            m_est=m2_est;
            m_est(1:NoOfLeadingAddedZeros)=[];
            m_est(end- NoOFTrailingAddedZeros+1:end)=[];
            NoOfBitErrors=NoOfBitErrors+length(find(m_est~=m));
            TotalNoOfBits=TotalNoOfBits+length(m_est);
            NoofCodedBitErrors=NoofCodedBitErrors+length(find(c_bin_est~=c_bin));
            TotalNoOfCodedBits=TotalNoOfCodedBits+length(c_bin);

        end
        BER(Simulation,SNR)=NoOfBitErrors./TotalNoOfBits;
        BER2(Simulation,SNR)=NoofCodedBitErrors./TotalNoOfCodedBits;
        clc
        disp(['Sim:' num2str(100.*(countSNRs)./(10.*length(EbNodBVals))) '% ,' ' Eb/No= ' num2str(EbNodBVals(SNR)) ' dB , BER = ' num2str(BER(Simulation,SNR))])
    end
end
%===============================================================
% Draw the The Figures of results
%==============================================================
disp('Information for this code')
disp('==========================')
disp([ 'k = ' num2str(k) ' input bits'])
disp(['n = ' num2str(n) ' output bits'])
disp(['code rate = ' num2str(coderate)])
disp(['Total Number of Memory Elements M = ' num2str(sum(M))]);
disp(['Total Number of States : ' num2str(2.^(sum(M)))]);
disp(['Constraint Length nu : ' num2str(nu)]);
disp('==========================')
AverageBER=mean(BER);
semilogy(EbNodBVals,AverageBER,'-*')
xlabel('SNR(dB)')
ylabel('BER(log)')
legend('The BER of System')
title('System BER performance')
figure(gcf)