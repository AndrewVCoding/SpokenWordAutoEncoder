cd('A:\cv-corpus-5.1-2020-06-22\en\');

num_pairs = 200;
resample_rate = 48000;
num_windows = 15;
window_overlap = 0.8;

% Prep the training data
inputs = {};
for i = 1:numel(data(:,1))
    f1 = ['clips\', char(data.record_id(i)), '.mp3'];
    s1 = process(f1, data.start(i), data.xEnd(i), resample_rate, num_windows, window_overlap);
    if ~isempty(s1)
        inputs{end+1} = [data.word_id(i); s1'];
    end
    if mod(i, 100) == 0
        disp([num2str(i), '/', num2str(numel(data(:,1)))]);
    end
end

num_clips = numel(inputs);

training_data = {};
for i = 1:numel(inputs)
    c1 = cell2mat(inputs(i));
    n = 0;
    for j = 1:numel(inputs)
        c2 = cell2mat(inputs(j));
        if c1(1) == c2(1) && n < num_pairs
            training_data{end+1} = [c1; c2(2:3*num_windows+1,1)];
            n = n + 1;
        end
    end
end
cd('C:\Users\andre\OneDrive\SCHOOL\2020 Fall\Speech Perception Lab');

td = cell2mat(training_data)';
td(:,2:6*num_windows+1) = td(:,2:6*num_windows+1)./max(max(td));

training_set_size = size(training_data);

inputs = cell2mat(inputs)';
inputs(:,2:3*num_windows+1) = inputs(:,2:3*num_windows+1)./max(max(inputs));

function input_data = process(file, start_time, end_time, resample_rate, num_windows, window_overlap)
    try
        [y, fs] = audioread(file);
        y = resample(y, resample_rate, fs);
        % Get the sample numbers for the beginning and ending of the clip
        t1 = floor(start_time * resample_rate);
        t2 = floor(end_time * resample_rate);
        % Check that the provided clip fits within the audio file
        x = size(y(:,1));
        fit = t2 < x(1);
        clip_length = (t2-t1);
        if fit(1) && clip_length < 2 * resample_rate
            clip = y;
            window_size = floor(clip_length / num_windows);
            formants = [];
            % Compute formant frequencies for each window
            for t = 1:num_windows
                w1 = floor((t-1)*window_size) + t1;
                w2 = floor(min(w1 + window_size * (1+window_overlap), x));
                win = clip(w1:w2);
                formants(:,t) = formant_measure(win, resample_rate);
            end
            input_data = reshape(formants, [1, numel(formants)]);
        else
            input_data = [];
        end
    catch
        input_data = [];
    end
end

function formants = formant_measure(x, fs)
    preemph = [1 0.63];
    x = filter(1, preemph, x);
    A = lpc(x,8);
    rts = roots(A);
    rts = rts(imag(rts)>=0);
    angz = atan2(imag(rts),real(rts));
    [frqs,indices] = sort(angz.*(fs/(2*pi)));
    bw = -1/2*(fs/(2*pi))*log(abs(rts(indices)));
    nn = 1;
    for kk = 1:length(frqs)
        if (frqs(kk) > 90 && bw(kk) <400)
            formants(nn) = frqs(kk);
            nn = nn+1;
        end
    end
    formants = round(frqs(1:3));
end