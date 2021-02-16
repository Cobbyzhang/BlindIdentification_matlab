function [ T ] = Identify_T_backup( x,xt,v )
%% Ԥ������
v = reshape(v,1,[]);
[k,~] = size(x);
T = zeros(k);
vMax = max(v); % ����vi
vMin = min(v); % ��С��vi
v_count = [1:vMax;zeros(1,vMax)]; % vCount ��ʾÿ��ֵ�ж��ٸ�vi������vMin��vMax֮����ֵ����һ�б�ʾvi��ֵ���ڶ��б�ʾ���ֵ��vi����
for iter = 1:numel(v)
    v_count(2,v(iter)) = v_count(2,v(iter)) + 1; %��v��ͳ�ƣ����vCount����
end
Row_certain_x = []; %�Ѿ�ȷ��ƥ���x
Row_certain_xt = []; % �Ѿ�ȷ��ƥ���xt
inclusion_x = 1:k;   % ��δƥ���x
inclusion_xt = 1:k;  % ��δƥ���xt
%% ƥ�����
for iterv = vMax:-1:vMin  %ÿ��ƥ��vNum��x,xt����
    vNum = v_count(2,iterv);
    Traversal = GenerateTraversal(Row_certain_xt);  %���������ϵ��
    tLen = size(Traversal,2); %��¼���������漰���кŸ���
    if isempty(Row_certain_xt)
        rowTraversal = zeros(1,size(x,2)); %����ǳ�ʼ��û��һ��ƥ���xt����ʼλȫ��
    else
        rowTraversal = RowCalculation(xt,Row_certain_xt(1,:),Traversal); %�������������ж�Ӧ������
    end 
    vNumFlag = vNum; % ����vNum��ı䣬���һ����Ϊһ��forѭ���Ľڵ�
    for itern = 1:vNumFlag  % ÿ����itern��Ԫ�ص��Ӽ�
        if vNum == 0 
            break
        end
        Combination = nchoosek(inclusion_xt,itern); % ����xt��δƥ���Ԫ�ص�iternԪ�Ӽ� �����к���
        rowCombination = RowCalculation(xt,Combination); %����xt��δƥ���Ԫ�ص�iternԪ�Ӽ� ������������
        for iterr = 1:size(rowTraversal,1)
            % ��rowTraversal�ĵ�iter�м��뵽rowCombination��ÿһ�У�Ȼ����x��Ѱ���Ƿ�����ȫƥ��
            % �������rowNumber��һ��ȫ�������
            % rowNumber��ֵ��Ӧ��rowTravelsal���к�
            rowNumber = FindRow(bsxfun(@xor,rowCombination,rowTraversal(iterr,:)),x,inclusion_x); 
            if any(rowNumber) % �ҵ���ƥ�����
                % �ҵ�rowNumber����Щ�з�����ƥ�䣨�кŶ�ӦCombination�кţ�
                pp = find(rowNumber); 
                %pp(ismember(rowNumber(pp),Row_certain_x)==0)=[];
                Row_certain_x = [Row_certain_x,rowNumber(pp).']; % ����Row_certain_x
                inclusion_x = setdiff(inclusion_x,rowNumber(pp));% ����inclusion_x
                % �ҵ�Combination��ֵ��Ӧ��inclusion_xt�е���
                rr = unique(reshape(Combination(pp,:),1,[]));
                rr(ismember(rr,Row_certain_xt)==1)=[];% ȥ���Ѿ��������
                Row_certain_xt = [Row_certain_xt,[rr;ones(size(rr))]];% ����Row_certain_xt
                for iterp = 1:numel(pp) % �������T��pp������ʾһ��ƥ��ĸ�����
                    %T(Combination(pp(iterp),:), pp(iterp)) = ones(Combination(pp(iterp),:),1);
                    % ��inclusion_xt�������д���Ӧ����
                    T(Combination(pp(iterp),:), rowNumber(pp(iterp))) = 1;
                    if tLen>0
                        % ��row_certain_xt��Ӧ���м���Ȩϵ��д���Ӧ����
                        T(Row_certain_xt(1,1:tLen), rowNumber(pp(iterp))) = Traversal(iterr,:).';
                    end
                end
                vNum = vNum - numel(pp); % ��δ�ҵ��ĸ���
            end
        end
        if vNum <= 0 
            break
        end
    end
    if ~isempty(Row_certain_xt) 
        inclusion_xt = setdiff(1:k,Row_certain_xt(1,:));% ����inclusion_xt
        Row_certain_xt(2,:) = Row_certain_xt(2,:) * 2 + 1; % ������ȷ��ֵ���Գ˵����ϵ����
    end
    if isempty(inclusion_xt) %����Ѿ�ȫ���ҵ�Ӧ����ʱ�˳�����ʡʱ��
        break
    end
    if vNum > 0 %ĳһ��������û��ȫ���ҵ�vNum��ƥ�䣬�����
        disp('Fail to identify T');
        return
    end
end
end