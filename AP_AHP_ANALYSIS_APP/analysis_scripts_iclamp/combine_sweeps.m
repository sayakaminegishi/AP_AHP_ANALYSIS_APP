%this function gets rid of the transient spike at the start of every sweep
%and then combines the data from all the sweeps into a single sweep array.

%Original script by: Sayaka (Saya) Minegishi
% November 3 2023

%THIS CODE RUNS

function combinedsweep = combine_sweeps(dataallsweeps)

    numpointspersweep = size(dataallsweeps, 1); %total number of points per sweep
    totalsweeps=size(dataallsweeps,3); %total number of sweeps in this 'continuous' abf file
   
    transient_duration = 0.078 * (103224/10.3224); %the length of the transient. in sample units. Cuts off the first 0.078 seconds of sweep.
    %display(numpointspersweep)
   % display(totalsweeps)

    arrsize = ((numpointspersweep-transient_duration) * totalsweeps); %size of array (column vector)
    combinedsweep = zeros(arrsize,1); %array to store the waveform of combined sweep. a column vector
    counter = 1; %keeps track of the first index of combinedsweep that needs to be filled
    
    for a = 1:totalsweeps
        data=dataallsweeps(:,1,a); %data from ath  sweep
        % TODO: get rid of transient here
         
         data = data(transient_duration + 1:numpointspersweep); % cut out data 

        combinedsweep(counter:numpointspersweep-transient_duration + counter-1) = data;
        counter = counter + numel(data);
    end
end







