a=2;
x=0.2;
i=10;

values = zeros(1, i);   % create storage

% Loop
for n = 1:i
    x = a * x.* (1 - x);
    values(n) = x;

end
    figure;
    plot(values)