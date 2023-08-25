# the prepare step only applies to the dsns data

folder:=dsns/logstash-victim.chromo-jsenhance-2021-09-10

all: prepare run map plot compute merge nmd

prepare:
	python prepare_dsns_data.py $(folder)
	
run:
	julia run_models.jl ../data/$(folder) -s true --stop_after_n_structures 100. --stop_threshold 300. -o true

map:
	python map_results.py $(folder)

plot:
	python plot_models.py $(folder)

compute:
	python compute_structure_alignment.py $(folder)

merge:
	python merge_alignments.py $(folder)

nmd:
	python compute_graph_distance.py $(folder)