% http://www.vibrationdata.com/matlab2/Craig_Bampton.m
disp(' ');
disp(' Craig_Bampton.m  ver 1.0  April 30, 2013 ');
disp(' ');
disp(' by Tom Irvine ');
%
clear mass;
clear m;
clear k;
%
clear M11;
clear M12;
clear M21;
clear M22;
%
clear K11;
clear K12;
clear K21;
clear K22;
%
clear mq;
clear kq;
clear m_partition;
clear k_partition;
%
clear CBTM;
clear ngw;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
tpi=2.*pi;
%
disp(' ');
disp(' Enter the units system ');
disp(' 1=English  2=metric ');
iu=input(' ');
%
disp(' ');
disp(' Assume symmetric mass and stiffness matrices. ');
disp(' ');
%
mass_scale=1;
%
if(iu==1)
     disp(' Select input mass unit ');
     disp('  1=lbm  2=lbf sec^2/in  ');
     imu=input(' ');
     if(imu==1)
         mass_scale=386;
     end
else
    disp(' mass unit = kg ');
end
%
disp(' ');
if(iu==1)
    disp(' stiffness unit = lbf/in ');
else
    disp(' stiffness unit = N/m ');
end
%
%
disp(' ');
disp(' Select file input method ');
disp('   1=file preloaded into Matlab ');
disp('   2=Excel file ');
file_choice = input('');
%
disp(' ');
disp(' Mass Matrix ');
%
if(file_choice==1)
        m = input(' Enter the matrix name:  ');
end
if(file_choice==2)
        [filename, pathname] = uigetfile('*.*');
        xfile = fullfile(pathname, filename);
%        
        m = xlsread(xfile);
%         
end
%
m=m/mass_scale;
%
mass=m;
%
disp(' ');
disp(' Stiffness Matrix ');
%
if(file_choice==1)
        k = input(' Enter the matrix name:  ');
end
if(file_choice==2)
        [filename, pathname] = uigetfile('*.*');
        xfile = fullfile(pathname, filename);
%        
        k = xlsread(xfile);
%         
end
stiffness=k;
%
size(m);
size(k);
%
num=max(size(m));
%
disp(' ');
disp(' The mass matrix is');
m
disp(' ');
disp(' The stiffness matrix is');
k
%
disp(' ');
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
num_boundary=input(' Enter number of boundary dof ');
%
num_interior=num-num_boundary;
%
dof_boundary=zeros(num_boundary,1);
dof_interior=zeros(num_interior,1);
%
for i=1:num_boundary
    out1=sprintf(' Enter boundary dof %d: ',i);
    dof_boundary(i)=input(out1);
end
%
ijk=1;
for i=1:num
    iflag=0;
    for j=1:num_boundary
        if(i==dof_boundary(j))
            iflag=1;
            break;
        end
    end
%
    if(iflag==0)
        dof_interior(ijk)=i;
        ngw(ijk)=i;
        ijk=ijk+1;
    end
%
end    
%
ngw((num_interior+1):num)=dof_boundary;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
[M11,M12,M21,M22,K11,K12,K21,K22]=...
                               CB_partition(dof_boundary,dof_interior,m,k);
%
disp(' ');
disp(' ** Fixed Interface Flexible Natural Frequencies & Modes ** ');
disp(' ');
%
[fn,omega,ModeShapes,MST]=Generalized_Eigen(K11,M11,1);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp(' ');
num_keep=input(' Enter number of modes to keep ');
%
num_columns=num_keep+num_boundary;
%
CBTM=zeros(num,num_columns);
%
invK11=pinv(K11);
%
CC=-invK11*K12;
%
j=1;
%
CBTM(1:num_interior,1:num_keep)=ModeShapes(1:num_interior,1:num_keep);
%
for i=(num_keep+1):num_columns
    CBTM(1:num_interior,i)=CC(1:num_interior,j);
    j=j+1;
end
%
for i=(num_interior+1):num
    for j=(num_keep+1):num_columns
        CBTM(i,j)=1;
    end    
end
%
disp(' ');
disp(' Craig-Bampton Transformation Matrix ');
CBTM
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
m_partition(1:num_interior,1:num_interior)        =M11;
m_partition(1:num_interior,num_interior+1:num)    =M12;
m_partition(num_interior+1:num,1:num_interior)    =M21;
m_partition(num_interior+1:num,num_interior+1:num)=M22;
%
k_partition(1:num_interior,1:num_interior)        =K11;
k_partition(1:num_interior,num_interior+1:num)    =K12;
k_partition(num_interior+1:num,1:num_interior)    =K21;
k_partition(num_interior+1:num,num_interior+1:num)=K22;
%
disp(' ');
disp(' Partitioned Matrices ');
%
m_partition
k_partition
%
%
disp(' Transformed matrices (reduced component matrices)');
%
mq=CBTM'*m_partition*CBTM
kq=CBTM'*k_partition*CBTM
%
disp(' ');
disp(' order vector ');
ngw