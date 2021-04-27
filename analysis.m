% plot word groups using the first two values of their reduced vectors
words = {};
x = size(training_data);
for i = 1:x(2)
    original = training_data{i};
    nn.feedForward(original(2:201)');
    reduced = nn.hidden_activation;
    word = [training_data{i}(1) reduced];
    words.word_id(i) = training_data{i}(1);
    words.reduction(i) = {reduced};
end