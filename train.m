rng default
warning('off','MATLAB:rankDeficientMatrix');

iterations = 50000; % Number of examples to train the model on
batch_size = 10; % Number of examples in each batch
analysis = 10; % How many batches to train before computing analysis

% Train the network
gf = nn.grouping_factor(end);
gamma = [0.1];
for i = 1:batch_size:iterations
    input = zeros(batch_size,nn.input_size);
    label = zeros(batch_size,nn.input_size);
    for j = 1:batch_size-1 % Construct the batch by randomly sampling the training data
        row = datasample(td, 1);
        input(j,:) = row(2:46);
        label(j,:) = row(47:91);
    end
    
    nn.train(input, label, gamma(end), batch_size);
    
    if mod(i-1,analysis*batch_size) == 0 % Analyze the grouping factor of the reduced vectors
        disp(['batch: ' , num2str((i-1)/batch_size), '/', num2str(floor(iterations/batch_size))]);
        reduced_vectors_post_training = get_reduced_vectors(inputs, nn);
        gf = nn.grouping_factor(end);
        nn.add_grouping_factor(analyze_grouping_factor(reduced_vectors_post_training));
    end
    gamma = [gamma 0.1/i];
end

figure(1)
tiledlayout(1,2)

nexttile
plot(nn.loss);
title('A')
xlabel('training batch')
ylabel('loss')
box off

nexttile
x1 = linspace(0,501,501);
p1 = polyfit(x1, nn.grouping_factor,1);
y1 = polyval(p1,x1);
plot(nn.grouping_factor)
hold on
plot(x1,y1)
hold off
% ylim([1 2])
xlim([0 501])
title('B')
xlabel('batch (10 per)')
ylabel('grouping factor')
box off