function [w_reservation]=reserve(b,bet)

pd = makedist('Binomial','N',150,'p',0.25);
w = 10:1:60; %wage values
p = pdf(pd,w); %associated probabilities

%iteration to find v
%initial guess -always accept
v = w/(1-bet);
max_n_iter=100;
n_iter_4=0;
%tolerance level
conv_tol=0.001;
diff_v=10;

%loop
while abs(diff_v)>conv_tol && n_iter_4<max_n_iter
    n_iter_4=n_iter_4+1;
    v_next=max(w/(1-bet),b+bet*sum(v.*p));
    diff_v=max(abs(v-v_next));
    v=v_next;
end 


% reservation wage
w_reservation =v(1)*(1-bet);
end