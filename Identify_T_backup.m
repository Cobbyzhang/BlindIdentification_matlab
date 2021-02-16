function [ T ] = Identify_T_backup( x,xt,v )
%% 预处理工作
v = reshape(v,1,[]);
[k,~] = size(x);
T = zeros(k);
vMax = max(v); % 最大的vi
vMin = min(v); % 最小的vi
v_count = [1:vMax;zeros(1,vMax)]; % vCount 表示每个值有多少个vi，尽在vMin：vMax之间有值；第一行表示vi的值，第二行表示这个值得vi个数
for iter = 1:numel(v)
    v_count(2,v(iter)) = v_count(2,v(iter)) + 1; %对v做统计，完成vCount计算
end
Row_certain_x = []; %已经确定匹配的x
Row_certain_xt = []; % 已经确定匹配的xt
inclusion_x = 1:k;   % 尚未匹配的x
inclusion_xt = 1:k;  % 尚未匹配的xt
%% 匹配计算
for iterv = vMax:-1:vMin  %每次匹配vNum个x,xt向量
    vNum = v_count(2,iterv);
    Traversal = GenerateTraversal(Row_certain_xt);  %遍历矩阵的系数
    tLen = size(Traversal,2); %记录遍历矩阵涉及的行号个数
    if isempty(Row_certain_xt)
        rowTraversal = zeros(1,size(x,2)); %如果是初始还没有一个匹配的xt，初始位全零
    else
        rowTraversal = RowCalculation(xt,Row_certain_xt(1,:),Traversal); %计算遍历矩阵各行对应的向量
    end 
    vNumFlag = vNum; % 由于vNum会改变，标记一下作为一个for循环的节点
    for itern = 1:vNumFlag  % 每次找itern个元素的子集
        if vNum == 0 
            break
        end
        Combination = nchoosek(inclusion_xt,itern); % 生成xt尚未匹配的元素的itern元子集 关于行号码
        rowCombination = RowCalculation(xt,Combination); %生成xt尚未匹配的元素的itern元子集 关于向量计算
        for iterr = 1:size(rowTraversal,1)
            % 把rowTraversal的第iter行加入到rowCombination的每一行，然后在x中寻找是否有完全匹配
            % 多数情况rowNumber是一个全零的向量
            % rowNumber的值对应是rowTravelsal的行号
            rowNumber = FindRow(bsxfun(@xor,rowCombination,rowTraversal(iterr,:)),x,inclusion_x); 
            if any(rowNumber) % 找到了匹配情况
                % 找到rowNumber中哪些行发生了匹配（行号对应Combination行号）
                pp = find(rowNumber); 
                %pp(ismember(rowNumber(pp),Row_certain_x)==0)=[];
                Row_certain_x = [Row_certain_x,rowNumber(pp).']; % 更新Row_certain_x
                inclusion_x = setdiff(inclusion_x,rowNumber(pp));% 更新inclusion_x
                % 找到Combination的值对应的inclusion_xt中的行
                rr = unique(reshape(Combination(pp,:),1,[]));
                rr(ismember(rr,Row_certain_xt)==1)=[];% 去掉已经加入的项
                Row_certain_xt = [Row_certain_xt,[rr;ones(size(rr))]];% 更新Row_certain_xt
                for iterp = 1:numel(pp) % 逐列添加T（pp个数表示一次匹配的个数）
                    %T(Combination(pp(iterp),:), pp(iterp)) = ones(Combination(pp(iterp),:),1);
                    % 把inclusion_xt参与的行写入对应的列
                    T(Combination(pp(iterp),:), rowNumber(pp(iterp))) = 1;
                    if tLen>0
                        % 把row_certain_xt对应的列及加权系数写入对应的列
                        T(Row_certain_xt(1,1:tLen), rowNumber(pp(iterp))) = Traversal(iterr,:).';
                    end
                end
                vNum = vNum - numel(pp); % 尚未找到的个数
            end
        end
        if vNum <= 0 
            break
        end
    end
    if ~isempty(Row_certain_xt) 
        inclusion_xt = setdiff(1:k,Row_certain_xt(1,:));% 更新inclusion_xt
        Row_certain_xt(2,:) = Row_certain_xt(2,:) * 2 + 1; % 更新已确定值可以乘的最大系数的
    end
    if isempty(inclusion_xt) %如果已经全部找到应当及时退出，节省时间
        break
    end
    if vNum > 0 %某一次运行完没有全部找到vNum个匹配，则出错
        disp('Fail to identify T');
        return
    end
end
end