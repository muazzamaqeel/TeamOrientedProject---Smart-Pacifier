%% Pacifier HDF5 Dynamic Visualizer
% Automatically:
%  - loads newest .h5 recording
%  - scans all groups recursively
%  - plots all datasets that contain timestamps
%  - displays metadata

clear; clc; close all;

%% -----------------------------------------------------------
% FIND HDF5 FILE
%% -----------------------------------------------------------

script_dir = fileparts(mfilename('fullpath'));
data_dir   = fullfile(script_dir, '..', 'data');

files = dir(fullfile(data_dir, '*_data.h5'));

if isempty(files)
    error("No *_data.h5 file found in %s", data_dir);
end

[~, idx] = max([files.datenum]);
h5file = fullfile(files(idx).folder, files(idx).name);

fprintf("Loading file: %s\n", h5file);

info = h5info(h5file);

%% -----------------------------------------------------------
% DISPLAY SESSION METADATA
%% -----------------------------------------------------------

fprintf("\n=========== SESSION METADATA ===========\n");

meta = struct();

if isfield(info,"Attributes") && ~isempty(info.Attributes)

    for i = 1:numel(info.Attributes)

        name  = info.Attributes(i).Name;
        value = h5readatt(h5file,"/",name);

        if isnumeric(value)
            value = num2str(value);
        end

        fprintf("%s : %s\n",name,value);
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

title("Session Metadata","FontSize",14,"FontWeight","bold");

text_y = 0.95;
fields = fieldnames(meta);

for i = 1:numel(fields)

    txt = sprintf("%s : %s",fields{i},meta.(fields{i}));

    text(0.02,text_y,txt, ...
        "FontSize",11, ...
        "Interpreter","none", ...
        "FontWeight","bold");

    text_y = text_y - 0.06;
end

axis off

%% -----------------------------------------------------------
% PROCESS GROUPS RECURSIVELY
%% -----------------------------------------------------------

process_group(h5file,"/",info)

fprintf("\nAll sensors plotted dynamically.\n");

%% ===========================================================
% RECURSIVE GROUP PROCESSOR
%% ===========================================================

function process_group(h5file,group_path,group_info)

    % Check datasets in this group
    dataset_names = {};
    
    if ~isempty(group_info.Datasets)
        dataset_names = {group_info.Datasets.Name};
    end
    if any(strcmp(dataset_names,"timestamp"))

        fprintf("\nProcessing sensor group: %s\n",group_path);

        %% Read timestamp
        timestamp_path = fullfile_path(group_path,"timestamp");

        t = h5read(h5file,timestamp_path);
        t = t(:);
        t = t - t(1);

        dataset_names(strcmp(dataset_names,"timestamp")) = [];

        %% Plot datasets
        for d = 1:numel(dataset_names)

            name = dataset_names{d};

            data_path = fullfile_path(group_path,name);

            data = h5read(h5file,data_path);
            data = data(:);

            figure("Name",group_path + " : " + name,"Color","w");

            plot(t,data,"LineWidth",1.5);
            grid on

            title(strrep(name,"_","."),"Interpreter","none")
            xlabel("Time (s)")

            try
                units = h5readatt(h5file,data_path,"units");
                ylabel(units)
            catch
                ylabel("value")
            end

            fix_axes()

        end
    end

    %% Recurse into subgroups
    for i = 1:length(group_info.Groups)

        sub_group = group_info.Groups(i);

        process_group(h5file,sub_group.Name,sub_group)

    end

end

%% -----------------------------------------------------------
% SAFE HDF5 PATH BUILDER
%% -----------------------------------------------------------

function path = fullfile_path(group,name)

    if group == "/"
        path = "/" + name;
    else
        path = group + "/" + name;
    end

end

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

end