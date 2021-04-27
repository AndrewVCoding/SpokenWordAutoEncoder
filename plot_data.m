rng default

figure(2)
tiledlayout(1,2)

nexttile
features = tsne(inputs(:,2:46), 'NumDimensions',2);
gscatter(features(:,1),features(:,2),inputs(:,1))
title('A. features tsne');
box off
legend('it', 'was', 'the', 'of', 'to', 'a', 'is', 'he', 'and', 'in')

nexttile
features = tsne(inputs(:,2:46), 'NumDimensions',3);
scatter3(features(:,1),features(:,2),features(:,3),15,inputs(:,1),'filled')
title('B. features tsne');
box off
legend('it', 'was', 'the', 'of', 'to', 'a', 'is', 'he', 'and', 'in')

figure(3)
tiledlayout(2,2)

nexttile
pre = tsne(reduced_vectors_pre_training(:,2:end), 'NumDimensions',2);
gscatter(pre(:,1),pre(:,2),inputs(:,1))
title('A. pre-training tsne');
box off
legend('it', 'was', 'the', 'of', 'to', 'a', 'is', 'he', 'and', 'in')

nexttile
post = tsne(reduced_vectors_post_training(:,2:end), 'NumDimensions',2);
gscatter(post(:,1),post(:,2),inputs(:,1))
title('B. post-training tsne');
box off
legend('it', 'was', 'the', 'of', 'to', 'a', 'is', 'he', 'and', 'in')

nexttile
pre = tsne(reduced_vectors_pre_training(:,2:end), 'NumDimensions',3);
scatter3(pre(:,1),pre(:,2),pre(:,3),15,inputs(:,1),'filled')
title('C. pre-training tsne');
box off

nexttile
post = tsne(reduced_vectors_post_training(:,2:end), 'NumDimensions',3);
scatter3(post(:,1),post(:,2),post(:,3),15,inputs(:,1),'filled')
title('D. post-training tsne');
box off
