function grouping_factor = analyze_grouping_factor(v)
    % For each clip, find the average distance to other clips of the same word
    avg_within_group_distances = [];
    avg_between_group_distances = [];
    
    v = datasample(v,round(numel(v(:,1))/100));
    
    for i = 1:numel(v(:,1))
        c1 = v(i,:);
        within_group = {};
        between_group = {};

        for j = 1:numel(v(:,1))
            c2 = v(j,:);

            d = sqrt(c1*c2');

            if c1(1) == c2(1)
                within_group = [within_group; d];
            else
                between_group = [between_group; d];
            end
        end
        avg_within_group_distances = [avg_within_group_distances; mean(cell2mat(within_group))];
        avg_between_group_distances = [avg_between_group_distances; mean(cell2mat(between_group))];
    end

    grouping_factor = mean(avg_between_group_distances./avg_within_group_distances);
end