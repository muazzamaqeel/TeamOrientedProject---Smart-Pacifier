%% Pacifier HDF5 Dynamic Visualizer
% Dynamically:
%  - loads newest .h5 recording
%  - reads ALL sensors automatically
%  - plots each dataset in separate graphs
%  - displays metadata separately

clear; clc; close all;

%% -----------------------------------------------------------
% FIND HDF5 FILE
%% -----------------------------------------------------------

files = dir("**/*_data.h5");

if isempty(files)
    error("No *_data.h5 file found.");
end

% Pick newest recording
[~, idx] = max([files.datenum]);
h5file = fullfile(files(idx).folder, files(idx).name);

fprintf("Loading file: %s\n", h5file);

info = h5info(h5file);

%% -----------------------------------------------------------
% DISPLAY SESSION METADATA
%% -----------------------------------------------------------

fprintf("\n=========== SESSION METADATA ===========\n");

meta = struct();

if isfield(info, "Attributes") && ~isempty(info.Attributes)
    attrs = info.Attributes;

    for i = 1:numel(attrs)
        name  = attrs(i).Name;
        value = h5readatt(h5file, "/", name);

        if isnumeric(value)
            value = num2str(value);
        end

        fprintf("%s : %s\n", name, value);
        meta.(name) = value;
    end
else
    fprintf("No metadata attributes found.\n");
end

fprintf("========================================\n");

%% -----------------------------------------------------------
% METADATA WINDOW
%% -----------------------------------------------------------

figure("Name","Session Metadata","Color","w");
title("Session Metadata","Color","k","FontSize",14,"FontWeight","bold");

text_y = 0.95;
fields = fieldnames(meta);

for i = 1:numel(fields)
    txt = sprintf("%s : %s", fields{i}, meta.(fields{i}));
    text(0.01, text_y, txt, ...
        "FontSize", 11, ...
        "Interpreter","none", ...
        "Color","k", ...          % <-- force black text
        "FontWeight","bold");     % optional: improves readability
    text_y = text_y - 0.05;
end

axis off;


%% -----------------------------------------------------------
% PROCESS ALL SENSOR GROUPS DYNAMICALLY
%% -----------------------------------------------------------

group_names = {info.Groups.Name};

for g = 1:numel(group_names)

    group = group_names{g};
    fprintf("\nProcessing group: %s\n", group);

    ginfo = h5info(h5file, group);
    dataset_names = {ginfo.Datasets.Name};

    if ~ismember("timestamp", dataset_names)
        warning("No timestamp in %s, skipping", group);
        continue;
    end

    % Read time
    t = h5read(h5file, group + "/timestamp");
    t = t - t(1);

    % Remove timestamp from datasets
    dataset_names(strcmp(dataset_names,"timestamp")) = [];

    %% -------------------------------------------------------
    % PLOT EACH DATASET SEPARATELY
    %% -------------------------------------------------------

    for d = 1:numel(dataset_names)

        name = dataset_names{d};
        data = h5read(h5file, group + "/" + name);

        figure("Name", group + " : " + name, "Color", "w");

        plot(t, data, "LineWidth", 1.5);
        grid on;

        title(strrep(name,"_","."),"Interpreter","none");
        xlabel("Time (s)");

        % Auto unit detection from dataset attributes
        try
            units = h5readatt(h5file, group + "/" + name, "units");
            ylabel(units);
        catch
            ylabel("value");
        end

        fix_axes();
    end
end

fprintf("\nAll sensors plotted dynamically.\n");

%% -----------------------------------------------------------
% AXIS STYLE
%% -----------------------------------------------------------
function fix_axes()
    ax = gca;
    ax.Color = 'w';
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.GridColor = [0.8 0.8 0.8];
    ax.MinorGridColor = [0.9 0.9 0.9];

    ax.Title.Color  = 'k';
    ax.XLabel.Color = 'k';
    ax.YLabel.Color = 'k';
end
