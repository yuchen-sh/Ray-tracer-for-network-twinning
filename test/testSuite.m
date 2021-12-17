%TESTSUITE All tests are launched from this script.
% This should allow a maintainable and reliable update process.


% Copyright (c) 2019, University of Padova, Department of Information
% Engineering, SIGNET lab.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

clear
close all
clc

%% Run test suite
% % Runs a single precedure from exampleOutputsTest
% testResults = runtests('exampleOutputsTest',...
%     'ProcedureName', 'livingRoomTest',...
%     'OutputDetail', 3);

% Runs all procedures from exampleOutputsTest
testResults = runtests('exampleOutputsTest',...
    'OutputDetail', 3);
disp(testResults)