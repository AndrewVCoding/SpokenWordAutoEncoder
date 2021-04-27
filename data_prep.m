% Open the data labels
test_data = readtable('A:/cv-corpus-5.1-2020-06-22/en/train.txt');

% Save each sentence to it's own txt file with the same name as its audio
% file
% length(test_data.sentence)
for i=1:1000
    sentence = char(test_data.sentence(i));
    name = char(strcat('Project/sentences/', test_data.path(i)));
    name = strcat(name(1:length(name)-3), 'txt');
    fileid = fopen(name, 'w');
    fprintf(fileid, sentence);
    fclose(fileid);
    if rem(i,100) == 0
        % disp(i, '/', length(test_data.sentence), ' sentences processed')
        disp(i)
    end
end