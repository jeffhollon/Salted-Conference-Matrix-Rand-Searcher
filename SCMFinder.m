function [ SEQs ] = SCMFinder( N )
%SCMFINDER Finds 'salted conference matrices' of size N

    rng shuffle  %set random seed
    
    coeffs=getDevMat(N); %get the developed matrix

    %get N-2 random 1s and -1s

        trial=0;

        found=0;
        while ~found
            trial = trial + 1;
            if trial==1000000
                rng shuffle  %shuffle seed every 1000000 times
                trial=0;
            end
            Numbers = round(rand(1,N-2));
            Numbers( find(Numbers==0) ) = -1;
            Wtemp=[0, 1, Numbers];

                W=Wtemp(coeffs);
                Prod=W(1,:)*W';
                Prod = Prod(1,2:N);

                if max(abs(Prod)) <= 2
                    disp(Wtemp)
                    found=1;
                end
        end

end

