function ROI = niftiROI2mrVistaROI(ni, varargin)
% Convert a nifti to  into a mrVista Gray ROI
%
% ROI = niftiROI2mrVistaROI(ni, varargin)
%
%   INPUTS:
%       ni: a matrix, a nifti struct, or a path to a nifti file
%       Optional Inputs:
%           spath: a directory in which to save the ROI (if no path, then
%                 don't save; just return the ROI struct)
%           color: a 3-vector or color char (rbgcymkw)
%           comments: string for ROI.comments
%           name: string for ROI.name
%           layer: integer layer number in input matrix to be converted to
%                   ROI (Note that an ITK gray segmentation file can have
%                   any number of layers. We may want to convert only one
%                   of them to an ROI.)
%   OUTPUT:
%       ROI: a mrVista gray-view ROI struct
%
% see nifti2mrVistaAnat.m
%
% Example:
%
%   ni =   '3DAnatomy/t1_class.nii';
%   fname = 'LeftWhiteMatter'
%   col = 'm';
%   ROI = niftiROI2mrVistaROI(ni, 'name', fname, 'color', col, 'layer', 2);
%
% April, 2009: JW
% May 2012 KGS

%--------------------------------------------------------------
% variable check
if nargin > 1
    for ii = 1:2:length(varargin)
        switch lower(varargin{ii})
            case {'spath'}
                spath = varargin{ii+1};
            case {'color', 'roicolor'}
                ROI.color = varargin{ii+1};
            case 'comments'
                ROI.comments = varargin{ii+1};
            case {'name', 'roiname'}
                ROI.name = varargin{ii+1};
            case {'layer'}
                layer = varargin{ii+1};
            case{'roi'}
                ROI = varargin{ii+1};
            otherwise
                warning('Unknown input arg: %s', varargin{ii}); %#ok<WNTAG>
        end
    end
end
%--------------------------------------------------------------

% find non zero entries in nifti file that correspond to the roi
% we assume that the nifti file size is equal to the size of the volume
% typically 256 x 256 x 256
% Our NIFTI format is [(R), (P),(I)] format. 
% mrLoadRet coords are in [axial(S:I), coronal(A:P), sagittal(L:R)] format.
% This function permutes our preferred NIFTI format into our mrLoadRet format.

data = nifti2mrVistaAnat(ni);

ROIinds = find(data);

% Get the XYZ coordinates of these indices
[x y z] = ind2sub(size(data), ROIinds );

% Define a mrVista Gray ROI using these coordinates
ROI.coords   = single([x y z]');
ROI.created  = datestr(now);
ROI.modified = datestr(now);
ROI.viewType = 'Gray';
savename = ROI.name;
ROI.name = ROI.name(1:end-4); %this get rid of the .mat 
% Add optional or default ROI fields
if ~isfield(ROI, 'name'),     ROI.name = 'MyROI'; end
if ~isfield(ROI, 'color'),      ROI.color   = 'b'; end
if ~isfield(ROI, 'comments'),   ROI.comments = sprintf('%s: created by anat2roi', ROI.name); end

% If requested, save
if exist('spath', 'var'), save(fullfile(spath, savename), 'ROI'); end

% Done
return
