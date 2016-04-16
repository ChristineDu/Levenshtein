function [SE IE DE LEV_DIST] =Levenshtein(hypo_content,trans_content)
% Input:
%	hypo_content: cell array of hypothesis, each element is a string
%	trans_content: cell array of transcript or reference, each element is a string
% Outputs:
%	SE: proportion of substitution errors over all the hypotheses
%	IE: proportion of insertion errors over all the hypotheses
%	DE: proportion of deletion errors over all the hypotheses
%	LEV_DIST: proportion of overall error in all hypotheses

sub_error=0;
ins_error=0;
del_error=0;
errors=0;
reference_words=0;


% calculate levenshtein 
for index=1:numel(hypo_content)
	hypo = strsplit(hypo_content{index},' ');
	tran = strsplit(trans_content{index},' ');
	reference_words = reference_words + length(tran);

	n = length(tran);
	m = length(hypo);
	R = zeros(n+1,m+1);  % matrix of distance
	B = cell(n+1,m+1);   % cell array of backtracking
	R(1,:) = Inf;
	R(:,1) = Inf;
	R(1,1) = 0;
	for i = 2:n+1
		for j = 2:m+1
			del = R(i-1,j) +1;
			sub = R(i-1,j-1) + strcmp(tran{i},hypo{j});
			ins = R(i,j-1)+1;
			R(i,j) = min([del,sub,ins]);
			if R(i,j) == del
				B{i,j} = 'up';
			elseif R(i,j) == ins
				B{i,j} == 'left';
			else
				B{i,j} == 'up-left';
			end
		end
	end
	errors = errors + R(n+1,m+1);
	i = n+1;
	j = m+1;
	while i>1 && j>1
		if B{i,j} = 'up'
			i = i-1;
			del_error = del_error +1;
		elseif B{i,j} == 'left'
			j = j-1;
			ins_error = ins_error +1;
		elseif B{i,j} == 'up-left'
			i = i-1;
			j = j-1;
			sub_error = sub_error +1;
		else
			disp('error in backtracking');
		end
	end
end

SE = sub_error/reference_words
IE = ins_error/reference_words
DE = del_error/reference_words
LEV_DIST = errors/reference_words

return










