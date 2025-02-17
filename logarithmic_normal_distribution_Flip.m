function [x_axis,PDF_y_F,DF_y_F,Flip]=logarithmic_normal_distribution_Flip(L,T_1,T_b,T_e)
%% 对数正态分布 % https://zhuanlan.zhihu.com/p/490650039
ratio=1/3;
% early release ratio of intervention half effectiveness.
%% 

syms e_3sigma  %求解参数
eqn = e_3sigma -1 == ratio*(e_3sigma^2 -1);
S = solve(eqn);
double(S);
e_3sigma=double(S(2));
syms e_mu
eqn = e_mu*(1-(1/e_3sigma)) == ratio*L;
S = solve(eqn);
e_mu=double(S);
mu=log(e_mu);
sigma=log(e_3sigma)/3;

advance_cut=(e_mu*(1/e_3sigma));% 滞后期取值
x_L=(advance_cut:0.01:(L+advance_cut))';
PDF_L=lognpdf(x_L,mu,sigma);
DF_L = logncdf(x_L,mu,sigma)-lognpdf(advance_cut,mu,sigma);

x_L_R=((L+advance_cut):(-0.01):advance_cut)';
DF_L_F = logncdf(e_mu*e_3sigma,mu,sigma)-logncdf(x_L_R,mu,sigma);

PDF_L_F=flipud(PDF_L);


x_pre=(T_b:0.01:T_1)';PDF_pre=zeros(length(x_pre),1);DF_pre=zeros(length(x_pre),1);% 滞后期 前后 取值
x_post=((T_1+L):0.01:T_e)';PDF_post=zeros(length(x_post),1);DF_post=ones(length(x_post),1);

x_L=x_L+(T_1-advance_cut)*ones(length(x_L),1);

x_axis=[x_pre ;x_L; x_post];
PDF_y_F=[PDF_pre ;PDF_L_F ;PDF_post];
DF_y_F=[DF_pre ;DF_L_F; DF_post];

PDF_y=[PDF_pre ;PDF_L ;PDF_post];
DF_y=[DF_pre ;DF_L; DF_post];


Flip=[x_axis PDF_y DF_y PDF_y_F DF_y_F];

