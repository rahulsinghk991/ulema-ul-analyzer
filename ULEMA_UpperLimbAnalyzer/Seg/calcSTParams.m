%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function cycles = calcSTParams(cycles, stParPoints, kineFreq, anglesMinMaxEv, timing, speed, trajectory, jerk)

% The calculation are done for ALL the contexts

% Getting all the contexts
contexts = fieldnames(cycles);
% Cleaning the stParPoints from empty entries
stParPoints = cleanTableFromEmptyLines(stParPoints);

% Angle parameters
for co = 1 : length(contexts) % Cycle for every context found
    for cy = 1 : length(cycles.(contexts{co})) % Cycle for every movement cycle in a context
        phases = fieldnames(cycles.(contexts{co})(cy).data.anglesCut);
        for p = 1 : length(phases)
            phase = phases{p};
            angles = fieldnames(cycles.(contexts{co})(cy).data.anglesCut.(phase));
            for a = 1 : length(angles)
                angle = angles{a};
                if anglesMinMaxEv == 1
                    cycles.(contexts{co})(cy).data.stParam.valuesInTime.(angle).(phase) = ...
                        addSTParam({'minValue','maxValue','startValue','endValue'},...
                        cycles.(contexts{co})(cy).data.pointsCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.EntireCycle,...
                        phase,...
                        angle,...
                        kineFreq);
                else
                    cycles.(contexts{co})(cy).data.stParam.valuesInTime.(angle).(phase) = [];
                end
            end
        end
    end
end

% Point parameters
for i = 1 : size(stParPoints,1) % Cycle for every marker to use
    mkr = stParPoints{i,1};
    phase = stParPoints{i,2};
    for co = 1 : length(contexts) % Cycle for every context found
        for cy = 1 : length(cycles.(contexts{co})) % Cycle for every movement cycle in a context
            if isfield(cycles.(contexts{1})(1).data.pointsCut.(phase),mkr)
                % Timing
                if timing == 1
                    cycles.(contexts{co})(cy).data.stParam.timing.(mkr).(phase) = ...
                        addSTParam({'duration','percentageTiming','timeVmax'},...
                        cycles.(contexts{co})(cy).data.pointsCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.EntireCycle,...
                        phase,...
                        mkr,...
                        kineFreq);
                else
                    cycles.(contexts{co})(cy).data.stParam.timing.(mkr).(phase) = [];
                end
                % Speed
                if speed == 1
                    cycles.(contexts{co})(cy).data.stParam.speed.(mkr).(phase) = ...
                        addSTParam({'Vmax'},...
                        cycles.(contexts{co})(cy).data.pointsCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.EntireCycle,...
                        phase,...
                        mkr,...
                        kineFreq);
                else
                    cycles.(contexts{co})(cy).data.stParam.speed.(mkr).(phase) = [];
                end
                % Trajectory straightness
                if trajectory == 1
                    cycles.(contexts{co})(cy).data.stParam.trajectory.(mkr).(phase) = ...
                        addSTParam({'trajectory'},...
                        cycles.(contexts{co})(cy).data.pointsCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.EntireCycle,...
                        phase,...
                        mkr,...
                        kineFreq);
                else
                    cycles.(contexts{co})(cy).data.stParam.trajectory.(mkr).(phase) = [];
                end
                % Jerk
                if jerk == 1
                    cycles.(contexts{co})(cy).data.stParam.jerk.(mkr).(phase) = ...
                        addSTParam({'jerk'},...
                        cycles.(contexts{co})(cy).data.pointsCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.(phase),...
                        cycles.(contexts{co})(cy).data.anglesCut.EntireCycle,...
                        phase,...
                        mkr,...
                        kineFreq);
                else
                    cycles.(contexts{co})(cy).data.stParam.jerk.(mkr).(phase) = [];
                end
            else
                cycles.(contexts{co})(cy).data.stParam.timing.(mkr).(phase) = NaN;
                cycles.(contexts{co})(cy).data.stParam.speed.(mkr).(phase) = NaN;
                cycles.(contexts{co})(cy).data.stParam.trajectory.(mkr).(phase) = NaN;
                cycles.(contexts{co})(cy).data.stParam.jerk.(mkr).(phase) = NaN;
                fprintf('\n     Tr: Marker %s doesn''t exist for context %s, cycle %d. Spatio-temporal parameters calculation for it ...', mkr, contexts{co}, cy);
            end

        end
    end
end
