function reduced = get_reduced_vectors(x, nn)
    % Obtain the reduced vector for each clip after training the network
    reduced = [];
    for r = 1:numel(x(:,1))
        reduced = [reduced; nn.reduce(x(r,2:46))];
    end

    reduced = [x(:,1) reduced];
end