function [ DevMat ] = getDevMat( GroupList )
%GETDEVMAT Returns the abelian group-developed matrix for defining location
%of coefficient.
%GroupList should be entered as [2 3 3] for the group Z2xZ3xZ3

    if size(GroupList,2)==1
        %cyclic
        N=GroupList(1);
        coeffs=1:N;
        Coeffs=zeros(N);
        Coeffs(1,:)=coeffs;
        for I=1:N
            for J=1:N
                Coeffs(I,J)=Coeffs(1,mod(J+N-I,N)+1);
            end
        end
        
    else
        %Enter the group.  Each size spaced.  Ex:  Z2 x Z5 x Z10 = [2 5 10]
        NumGroups = size(GroupList,2);
        NumElements = prod(GroupList);
        %Place all elements

        %place zeros for all entries
        Elements=-99*ones(NumGroups, NumElements);


        %start iterating
        for a=NumGroups:-1:1
            counter=0;
            for b=1:NumElements

                if a==NumGroups
                    Elements(a,b) = mod(b-1, GroupList(1,a));
                else
                    %repeat entry for all of next row

                    count = prod(GroupList(1,a+1:NumGroups));

                    if Elements(a,b)==-99

                        Elements(a,b:b+count-1) = mod(counter, GroupList(1,a));
                        counter=counter+1;
                    end

                end
            end
        end 

        %Find inverse entries
        for a=1:NumElements
            for b=1:NumElements

                E1=Elements(:,a);
                E2=Elements(:,b);

                E = E1+E2;
                for c=1:NumGroups
                    E(c,1)=mod( E(c,1), GroupList(1,c) );
                end


                if E==zeros(NumGroups,1)
                    Inverses(a)=b;
                end

            end
        end

        %Generate Matrices
        coeffs=1:NumElements;
        Coeffs=zeros(NumElements);
        Coeffs(1,:)=coeffs;

        for a=2:NumElements
            for b=1:NumElements

                E = Elements(:,b) + Elements(:,Inverses(a) );

                %mod each line
                for c=1:NumGroups
                    E(c,1)=mod( E(c,1), GroupList(1,c) );
                end

                %find where it exists in the element list
                Loc=0;
                for c=1:NumElements
                    if Elements(:,c)==E
                        Loc=c;
                        break
                    end
                end
                Coeffs(a,b)=coeffs(Loc);

            end
        end
    end

    DevMat = Coeffs;
    
end

