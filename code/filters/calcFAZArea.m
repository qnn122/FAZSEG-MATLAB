function [varargout, FAZarea] = calcFAZArea(im, varargin)
%% CALCFAZAREA calculates FAZ area in a segmented image
% Input:
%   im  :       a set of segmented images or just single imge
% 
% Optional:
%   convfact: conversion factor, depending on the system. Default = 0.0055
%   ispixel: if output pixel or not
%
% Example:
%   convfact = 0.0055;
%   FAZarea = calcFAZArea(im, 'convfact', convfact)
%   [FAZpixel, FAZarea] = calcFAZArea(im, 'convfact', convfact, 'ispixel', 1) % Output 2 colums, first pixel, second area
%

%% Checking things
%
p = inputParser;

% default value
defaultFactor = 0.00557;
defaultispixel = 0;

%
addParameter(p, 'convfact', defaultFactor, @isnumeric)
addParameter(p, 'ispixel', defaultispixel, @isnumeric)

%
parse(p, varargin{:})

% Compute FAZ area
FAZpixel = permute(sum(sum(im,1),2), [3 2 1]);

if p.Results.ispixel
    varargout = FAZpixel;
end

if p.Results.convfact ~= defaultFactor
    convfact = p.Results.convfact;
else
    convfact = defaultFactor;
end

FAZarea = FAZpixel*convfact^2;



    

