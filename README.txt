The goal of this project is to explore using an autoencoder to generate word embeddings from
audio, using input-output pairs that correspond to different recordings of the same word. Ideally, the
embedded vectors would be grouped together, multiple recordings of the same word would produce
similar vectors. This would allow the ANN some degree flexibility in its vocabulary, which would be
represented by clusters in the embedded space rather than by a set number of output nodes. The utility
of this would not necessarily be to identify the word being spoken, but as a language representation
model. Once trained, the model could be used as a preprocessing step for other networks.

Script order:

	1) load_data.m
	2) init_nn.m
	3) train.m
	4) post_train_reduced_vectors.m
	5) plot_data.m
	6) analyze_grouping.m
