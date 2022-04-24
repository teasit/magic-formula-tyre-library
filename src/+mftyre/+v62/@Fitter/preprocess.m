function [mfinputs] = preprocess(meas)
arguments
    meas tydex.Measurement
end
%% Convert to one large array for improved performance
param = {% TODO: turn slip currently ignored --> ''; add this later
    'FZW'
    'LONGSLIP'
    'SLIPANGL'
    'INCLANGL'
    ''
    'LONGVEL'
    'INFLPRES'
    };
mfinputs = zeros(length(meas),7);
endIdx = 0;
for num = 1:numel(meas)
    startIdx = endIdx + 1;
    endIdx = endIdx + length(meas(num));
    for i = 1:numel(param)
        if isempty(param{i})
            input = zeros(length(meas(num)),1);
        else
            input = meas(num).(param{i});
            if isscalar(input)
                input = input*ones(length(meas(num)),1);
            end
        end
        mfinputs(startIdx:endIdx,i) = input;
    end
end
end

