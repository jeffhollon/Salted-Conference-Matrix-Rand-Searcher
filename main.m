clear
tic
N=22;
STOPITS=500000;
its_no = 0;

Coeffs=1:N;
coeffs=zeros(N);
coeffs(1,:)=Coeffs;
for I=1:N
    for J=1:N
        %place the coeffs in the right places
        coeffs(I,J)=coeffs(1,mod(J+N-I,N)+1);
    end
end
        
%get N-2 random 1s and -1s

    trial=0;
   
    
    found=0;
    while ~found %&& trial<STOPITS
        trial = trial + 1;
        if trial==1000000
            rng shuffle
            RandStream.setGlobalStream(streams{labindex})
            trial=0;
        end
        Numbers = round(rand(1,N-2));
        Numbers( find(Numbers==0) ) = -1;
        Wtemp=[0, 1, Numbers];

%         if abs(sum(Wtemp))<=9
            W=Wtemp(coeffs);
            Prod=W(1,:)*W';
            Prod = Prod(1,2:N);

            if max(abs(Prod)) <= 2
                disp(Wtemp)
                found=1;
            end
%         end
    end

toc