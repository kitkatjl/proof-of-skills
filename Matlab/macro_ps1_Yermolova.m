%decline parameters
%unemployment benefit
b = 10;
%future period discounting
bet = 0.9;

%wage distribution
pd = makedist('Binomial','N',150,'p',0.25);
w = 10:1:60; %wage values
p = pdf(pd,w); %associated probabilities

% plot pdf
figure
plot(w,p,'LineWidth',2)
set(gca,'FontSize',12)
xlabel('wage -- $w_i$','interpreter','latex')
ylabel('probability -- $p_i$','interpreter','latex')
saveas(gcf, 'example2_distribution', 'pdf')

%iteration to find v
%initial guess: always accept
v = w/(1-bet);
max_n_iter=100;
n_iter=0;
%fixed tolerance
conv_tol=0.00001;
diff_v=10;
%initial vector 
v_vec=v;

%loop 1 
while abs(diff_v)>conv_tol && n_iter<max_n_iter
    n_iter=n_iter+1;
    v_next=max(w/(1-bet),b+bet*sum(v.*p));
    diff_v=max(abs(v-v_next));
    v=v_next;
    v_vec=[v_vec;v];
end 

% reservation wage with these parameters
w_res =v(1)*(1-bet)

%plot consecutive v guesses
figure
plot(v_vec,'LineWidth',1.5)
set(gca,'FontSize',12)
xlabel('iteration','interpreter','latex')
ylabel('value of decision made','interpreter','latex')

%nice graph explains a lot i like it. It shows the value of the decision we
%make depending on wage in each iterarion
figure
plot(w,v_vec,'Linewidth',2)
set(gca,'FontSize',12)
xlabel('wage -- $w_i$','Interpreter','latex')
ylabel('value of decision made','Interpreter','latex') 
%saveas (gcf,'example2_distribution','pdf')

%now the initial guess is independent of wage, I chose 500 
%i do it this way (w*0) because that is a quick way of getting a vector of
%the same size as w with all values=500
v_1= w*0+500;
n_iter_1=0;
diff_v_1=10;
v_vec_1=v_1;
%loop 2
while diff_v_1>conv_tol && n_iter_1<max_n_iter
    n_iter_1=n_iter_1+1;
    v_next_1=max(w/(1-bet),b+bet*sum(v_1.*p));
    diff_v_1=max(abs(v_1-v_next_1));
    v_1=v_next_1;
    v_vec_1=[v_vec_1;v_1];
end 

% reservation wage new
w_res1 =v_1(1)*(1-bet)

%plot consecutive v_1 guesses
figure
plot(v_vec_1,'LineWidth',1.5)
set(gca,'FontSize',12)
xlabel('iteration','interpreter','latex')
ylabel('value of decision made','interpreter','latex')

%nice graph for this case
figure
plot(w,v_vec_1,'Linewidth',2)
xlabel('wage -- $w_i$','interpreter','latex')
ylabel('value of decision made','interpreter','latex') 
figure



%heat
%i created a function called reserve that does exactly what we did before
%for chosen values of b and bet. You give it two values (b,bet) and it
%returns a reservation wage, the initial guess is always accepting the
%offer, the other parameters remain as before, the f-n is stored in a
%separate file (matlab requirement)

%just to check if works
reserve(10,0.9)
%we get the same result as before, so works

%for the heat map I need a matrix filled with wages for pairs of b and bet
%i do it with a nested loop
n_iter_2=0;
n_iter_3=0;
bet_1=0.1;
b_1=10;
F = reserve(b_1,bet_1);
%just so i have an initial matrix to add values to
H= zeros(5,1);

while n_iter_3<5
    %the inner loop is responsible for columns, bet grows from 0.1 by 0.2
    %to 0.9
    %each iteration
    while n_iter_2<4 
        bet_1=bet_1+0.2;
        F_new=reserve(b_1,bet_1);
        F = [F; F_new];
        n_iter_2=n_iter_2+1;
    end 
    %the outter loop is responsible for rows, b grows from 10 by 10 to 50
    %each iteration
  H= [H F];
  n_iter_3=n_iter_3+1;
  n_iter_2=0;
  b_1=b_1+10;
  bet_1=0.1;
  F = reserve(b_1,0.1);
end
%deleting the initial zeros i created
H(:,1) = [];
%rays for the x and y of the heat map
b_ray=10:10:50;
bet_ray=0.1:0.2:0.9;

heatmap(b_ray,bet_ray,H,'Title','A heat map of the reservation wages','XLabel','b','YLabel','β')




