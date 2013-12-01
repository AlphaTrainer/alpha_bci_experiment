%% package install - they are installed under ~/octave
%% recall its easy to look into functions with help and demo:
%% demo ("pwelch",1)
pkg install libs/specfun-1.1.0.tar.gz
pkg install libs/control-2.4.2.tar.gz
pkg install libs/general-1.3.2.tar.gz
pkg install libs/signal-1.2.2.tar.gz

%% load one or all packages
pkg load all

%% or just load a single package
%% pkg load specfun
%%

%% look up news on the packages: 
%% news ("signal")
%%
%% help pwelch
%%
