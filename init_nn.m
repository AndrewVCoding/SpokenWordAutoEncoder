rng default

nn = neuralNetwork(45, 10, 45);

% Obtain the reduced vector for each clip before training the network
reduced_vectors_pre_training = [];
for r = 1:num_clips
    reduced_vectors_pre_training = [reduced_vectors_pre_training; nn.reduce(inputs(r,2:46))];
end

reduced_vectors_pre_training = [inputs(:,1) reduced_vectors_pre_training];

nn.add_grouping_factor(analyze_grouping_factor(reduced_vectors_pre_training));