% Illustrate the squeeze-and-shift concept
% Clear command window
clc;

% Clear all variables
clear all;

% Close all figures
close all;

% Restore default paths
restoredefaultpath;

%% Settings
% Font size
fs = 12;

% Line width
lw = 3;

% Number of bins
numberOfBins = 20;

%% Formatting
% Colors
red         = [0.8500,  0.3250, 0.0980];
blue        = [0,       0.4470, 0.7410];
green       = [0.4660,  0.6740, 0.1880];
grey        = [0.25,    0.25,   0.25  ];
lightGrey   = [0.4,     0.4,    0.4   ];

% Set default font size
set(groot, 'DefaultAxesFontSize',   fs);

% Set default line widths
set(groot, 'DefaultLineLineWidth',  lw);
set(groot, 'DefaultStairLineWidth', lw);
set(groot, 'DefaultStemLineWidth',  lw);

%% Generate data
% Number of points
M = 3e2;

% Reset random number generator
rng(1);

% Means
mu = [1.0*ones(1, M); 1.0*ones(1, M); 1.9*ones(1, M)];

% Standard deviations
sigma = [0.4*ones(1, M); 0.04*ones(1, M); 0.04*ones(1, M)];

% Constraint
xmax = 2.0;

% Times
t = [linspace(datetime('2022-07-30 08:00'), datetime('2022-07-30 09:00'), M);
    linspace(datetime('2022-07-30 09:00'), datetime('2022-07-30 10:00'), M);
    linspace(datetime('2022-07-30 10:00'), datetime('2022-07-30 11:00'), M)];

% States
x = mu + sigma.*randn(3, size(t, 2));

%% Generate drift data
% Drift time
tDrift = linspace(datetime('2022-07-30 11:00'), datetime('2022-08-01 11:00'), 7*M);

% Auxiliary variable
alpha = 1./(1 + exp(-linspace(-4, 2, 7*M)));

% Drift mean and standard deviation
muDrift = 1.9 - (alpha - alpha(1))./(alpha(end) - alpha(1))*0.75;
sigmaDrift = 0.04*linspace(1, 6, 7*M);

% Drift data
xDrift = muDrift + sigmaDrift.*randn(1, size(tDrift, 2));

%% Visualize squeeze-and-shift concept
% Create figure
figure('Units', 'Normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);

% Select subfigure
subplot(1, 4, 1:3);

% Plot states
plot(            t(1, :),              x(1, :),  '-', 'Color', red,   'LineWidth', 2); hold on;
plot([t(1, end), t(2, :)], [x(1, end), x(2, :)], '-', 'Color', blue,  'LineWidth', 2);
plot([t(2, end), t(3, :)], [x(2, end), x(3, :)], '-', 'Color', green, 'LineWidth', 2);
plot([t(3, end), tDrift ], [x(3, end), xDrift ], '-', 'Color', grey,  'LineWidth', 2);

% Plots boundary
fill([t(1, 1), tDrift(end, end), tDrift(end, end), t(1, 1)], [xmax, xmax, 1e9, 1e9], ...
    lightGrey, 'FaceAlpha', 0.3, 'EdgeAlpha', 0); hold off;

% Axis limits
xlim([t(1, 1), tDrift(end, end)]);
ylim([0, 2.1]);

% Axis labels
ylabel('Outputs');

% Legend
legend('Original', 'Squeezed', 'Shifted', 'Drift', 'Bound', 'Location', 'Southeast');

% Select subfigure
subplot(1, 4, 4);

% Create histogram
histogram(x(1, :), numberOfBins, 'Normalization', 'Probability', ...
    'Orientation', 'Horizontal', ...
    'FaceColor', red, 'FaceAlpha', 1, 'EdgeAlpha', 0.025); hold on;

histogram(x(2, :), numberOfBins, 'Normalization', 'Probability', ...
    'Orientation', 'Horizontal', ...
    'FaceColor', blue, 'FaceAlpha', 1, 'EdgeAlpha', 0.025);

histogram(x(3, :), numberOfBins, 'Normalization', 'Probability', ...
    'Orientation', 'Horizontal', ...
    'FaceColor', green, 'FaceAlpha', 1, 'EdgeAlpha', 0.025);

histogram(xDrift, numberOfBins, 'Normalization', 'Probability', ...
    'Orientation', 'Horizontal', ...
    'FaceColor', grey, 'FaceAlpha', 1, 'EdgeAlpha', 0.025);

% Plots boundary
fill([0, 1, 1, 0], [xmax, xmax, 1e9, 1e9], ...
    lightGrey, 'FaceAlpha', 0.3, 'EdgeAlpha', 0); hold off;

% Axis limits
xlim([0, 0.15]);
ylim([0, 2.1]);

% Axis ticks
yticks([]);

% Axis tickmarks
xticklabels(1e2*str2double(xticklabels));

% Axis labels
xlabel('Percentage [%]');