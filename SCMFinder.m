function [ SEQs ] = SCMFinder( N, cores, timing)
%SCMFINDER Finds 'salted conference matrices' of size N
%An SCM is a ternary {-1,0,1} object such that its correlation (defined as
%WW^t has only {-2,0,2} entries in it.  It has exactly one 0 entry per row.
%cores defines the number of cores to be used for the searhc
%timing 1 displays time to compute

    if matlabpool('size') ~= cores
        delete(gcp)
        parpool(cores);  %open the threads
    end

    numWorkers=matlabpool('size')
    [streams{1:numWorkers}]= RandStream.create('mrg32k3a','Seed','shuffle','NumStreams',numWorkers)

    %in case N is not already just a number, turn it into the number of
    %elements it should correspond to:
    N = prod(N);
        
    spmd  %do each run on a separate thread
        
        if timing  %input arg set to 1
            TIME=0;  %set TIME to 0 on each thread
            tic
        end
        
        RandStream.setGlobalStream(streams{labindex});

        coeffs=getDevMat(N); %get the developed matrix

        %in case N is not already just a number, turn it into the number of
        %elements it should correspond to:
        N = prod(N);

        trial=0;      
        found=0;

        while ~found
            trial = trial + 1;
            if trial==1000000
                RandStream.setGlobalStream(streams{labindex})
                trial=0;
            end

            Numbers = round(rand(1,N-2)); %get random values for the last N-2 digits
            Numbers( find(Numbers==0) ) = -1; %make all 0s a -1
            Wtemp=[0, 1, Numbers];  %assume [0 1 ....] to start

            W=Wtemp(coeffs);  %makes the big matrix
            Prod=W(1,:)*W';  %computes the first row of correlation

            if max(abs(Prod(2:end))) <= 2  %if off diagonal entries are [+-2]
                %found one!
                disp(Wtemp)  %show the sequence
                disp(Prod)  %Show the correlation
                found=1;
                if timing
                    TIME = toc;
                end
            end
        end
        
    end

    %if timing is on, bring the parallel data back to main thread
    if timing %if timing is 1
        for i=1:cores
            T(i)=TIME{i};
        end
    end

    if timing
        disp(['Search time took ', num2str(sum(T)),' seconds'])
    end
    
%     delete(gcp)  %stop the cores
    
end

