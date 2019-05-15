function gui_disptable(datatable)
% DISPTABLE display data table on a figure, also providing basic statistics
% of the data, including mean, std, min and max.
%
% Input:
%   datatable: table storing data
%

% Display table
hfig = figure('Name', 'Comparison Result', ...
            'Units', 'normalized', 'Position',[0.45 0.2 0.35 0.65]);

data = datatable{:,:};
N = size(data,1);

% Add some basic stastictics
stats = [mean(data); std(data); min(data); max(data)];
data_augmented = [data; stats];

% Row of name accordingly
rowname = sprintfc('%d',1:N)';
rowname = cat(1, rowname, {'Mean'; 'STD'; 'Min'; 'Max'});

% Display result
uitable(hfig,'Data', data_augmented , 'ColumnWidth',{50}, ...
        'ColumnName', datatable.Properties.VariableNames, ...
        'Units', 'normalized', 'Position',[0.05 0.05 0.9 0.9], ...
        'RowName',rowname);