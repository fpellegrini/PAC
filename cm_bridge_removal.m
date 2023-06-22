function data = cm_bridge_removal(data)

[siz1, siz2] = size(data);

for ii =1:siz1
    for jj = 1:siz2
        
        if ii == 1
            
            if jj==1
                a = (data(ii+1,jj)+data(ii,jj+1)...
                    + data(ii+1,jj+1))/3;
            elseif jj == siz2
                a = (data(ii+1,jj)+data(ii,jj-1)...
                    + data(ii+1,jj-1))/3;
            else
                a = (data(ii+1,jj)+data(ii,jj-1)+data(ii,jj+1)...
                    + data(ii+1,jj-1) + data(ii+1,jj+1))/5;
            end
            
        elseif ii == siz1
            if jj==1
                a = (data(ii-1,jj)+data(ii,jj+1)...
                    + data(ii-1,jj+1))/3;
            elseif jj == siz2
                a = (data(ii-1,jj)+data(ii,jj-1)...
                    + data(ii-1,jj-1))/3;
            else
                a = (data(ii-1,jj)+data(ii,jj-1)+data(ii,jj+1)...
                    + data(ii-1,jj-1) + data(ii-1,jj+1))/5;
            end
        else
            if jj == 1
                a = (data(ii-1,jj)+data(ii+1,jj)+data(ii,jj+1)...
                    +  data(ii-1,jj+1) + data(ii+1,jj+1))/5;
            elseif jj == siz2
                a = (data(ii-1,jj)+data(ii+1,jj)+data(ii,jj-1)...
                    +  data(ii-1,jj-1) + data(ii+1,jj-1))/5;
            else
                
                a = (data(ii-1,jj)+data(ii+1,jj)+data(ii,jj-1)+data(ii,jj+1)...
                    + data(ii-1,jj-1) + data(ii-1,jj+1) + data(ii+1,jj-1)...
                    + data(ii+1,jj+1))/8;
            end
            
        end
        
        
        if abs(a)<0.5
            data(ii,jj)=0;
        end
    end
end