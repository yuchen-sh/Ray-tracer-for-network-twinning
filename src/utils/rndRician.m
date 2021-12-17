function r = rndRician(s, sigma, m ,n)
%RNDRICIAN Generate a matrix of size [m, n] with independent rician
%random variables. Parameters s and sigma follow MATLAB's Statistics and
%Machine Learning Toolbox RicianDistribution's description.


% Copyright (c) 2020, University of Padova, Department of Information
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

x = randn(m, n)*sigma + s;
y = randn(m, n)*sigma;
r = sqrt(x.^2 + y.^2);
end