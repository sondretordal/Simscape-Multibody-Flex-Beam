%
%   CB_partition.m  ver 1.0  April 30, 2013
%
function[M11,M12,M21,M22,K11,K12,K21,K22]=...
                               CB_partition(dof_boundary,dof_interior,m,k)
%
%%%%%%%%%%%%%%%%%%%%% M11 K11 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
num_boundary=length(dof_boundary);
num_interior=length(dof_interior);
%
num=num_boundary+num_interior;
%
M11=zeros(num_interior,num_interior);
M12=zeros(num_interior,num_boundary);
M21=zeros(num_boundary,num_interior);
M22=zeros(num_boundary,num_boundary);
%
K11=M11;
K12=M12;
K21=M21;
K22=M22;
%
ic=1;
for i=1:num
   iflag=0;          
   for nv=1:num_interior
      if(i==dof_interior(nv))
         iflag=1;
         break;
      end
   end
   if(iflag==1)
      jc=1;      
      for j=1:num
          jflag=0;
          for nv=1:num_interior
             if(j==dof_interior(nv))
                jflag=1;
                break;
             end   
          end
          if(jflag==1)
 %            out1=sprintf(' i=%d j=%d ic=%d jc=%d \n',i,j,ic,jc);
 %            disp(out1);             
             M11(ic,jc)=m(i,j);
             K11(ic,jc)=k(i,j);
             jc=jc+1;
          end
%         out1=sprintf(' i=%d j=%d iflag=%d jflag=%d \n',i,j,iflag,jflag);
%         disp(out1);
      end
   end
   if(iflag==1)
       ic=ic+1;
   end
end
%
%%%%%%%%%%%%%%%%%%%%% M12 K12 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ic=1;
for i=1:num
   iflag=0;          
   for nv=1:num_interior
      if(i==dof_interior(nv))
         iflag=1;
         break;
      end
   end
   if(iflag==1)
      jc=1;      
      for j=1:num
          jflag=0;
          for nv=1:num_interior
             if(j==dof_interior(nv))
                jflag=1;
                break;
             end   
          end
          if(jflag==0)
 %            out1=sprintf(' i=%d j=%d ic=%d jc=%d \n',i,j,ic,jc);
 %            disp(out1);             
             M12(ic,jc)=m(i,j);
             K12(ic,jc)=k(i,j);
             jc=jc+1;
          end
%         out1=sprintf(' i=%d j=%d iflag=%d jflag=%d \n',i,j,iflag,jflag);
%         disp(out1);
      end
   end
   if(iflag==1)
       ic=ic+1;
   end
end
%
%%%%%%%%%%%%%%%%%%%%% M21 K21 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ic=1;
for i=1:num
   iflag=0;          
   for nv=1:num_interior
      if(i==dof_interior(nv))
         iflag=1;
         break;
      end
   end
   if(iflag==0)
      jc=1;      
      for j=1:num
          jflag=0;
          for nv=1:num_interior
             if(j==dof_interior(nv))
                jflag=1;
                break;
             end   
          end
          if(jflag==1)
 %            out1=sprintf(' i=%d j=%d ic=%d jc=%d \n',i,j,ic,jc);
 %            disp(out1);             
             M21(ic,jc)=m(i,j);
             K21(ic,jc)=k(i,j);
             jc=jc+1;
          end
%         out1=sprintf(' i=%d j=%d iflag=%d jflag=%d \n',i,j,iflag,jflag);
%         disp(out1);
      end
   end
   if(iflag==0)
       ic=ic+1;
   end
end
%
%%%%%%%%%%%%%%%%%%%%%%% M22 K22 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ic=1;
for i=1:num
   iflag=0;          
   for nv=1:num_interior
      if(i==dof_interior(nv))
         iflag=1;
         break;
      end
   end
   if(iflag==0)
      jc=1;      
      for j=1:num
          jflag=0;
          for nv=1:num_interior
             if(j==dof_interior(nv))
                jflag=1;
                break;
             end   
          end
          if(jflag==0)
 %            out1=sprintf(' i=%d j=%d ic=%d jc=%d \n',i,j,ic,jc);
 %            disp(out1);             
             M22(ic,jc)=m(i,j);
             K22(ic,jc)=k(i,j);
             jc=jc+1;
          end
%         out1=sprintf(' i=%d j=%d iflag=%d jflag=%d \n',i,j,iflag,jflag);
%         disp(out1);
      end
   end
   if(iflag==0)
       ic=ic+1;
   end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%