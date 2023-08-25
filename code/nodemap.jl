module NodeMap

using DataFrames
using CSV

using LightGraphs
import LightGraphs.loadgraph
import GraphIO.EdgeList.EdgeListFormat

function collect_node_map(graph_file)
    G, node_map = loadgraph(graph_file, EdgeListFormat())
    return node_map
end

function build_graph(srcs::Vector{String}, dsts::Vector{String})
    vxset = unique(vcat(srcs, dsts))
    vxdict = Dict{String, Int}()
    for (v, k) in enumerate(vxset)
        vxdict[k] = v
    end

    n_v = length(vxset)
    g = LightGraphs.DiGraph(n_v)
    for (u, v) in zip(srcs, dsts)
        add_edge!(g, vxdict[u], vxdict[v])
    end
    return g, vxdict
end

function loadedgelist(io::IO)
    srcs = Vector{String}()
    dsts = Vector{String}()
    while !eof(io)
        line = strip(chomp(readline(io)))
        if !startswith(line, "#") && (line != "")
            r = r"([\w-]+)[\s,]+([\w-]+)"
            src_s, dst_s = match(r, line).captures
            push!(srcs, src_s)
            push!(dsts, dst_s)
        end
    end
    
    return build_graph(srcs, dsts)
end

function loadedgelist(gname::String)
    srcs = Vector{String}()
    dsts = Vector{String}()
    
    file = open(gname, "r")
    for line in eachline(file)
        line = strip(line)
        if !isempty(line)
            src, dst = split(line)
            push!(srcs, src)
            push!(dsts, dst)
        end
    end
    close(file)
    
    return build_graph(srcs, dsts)
end

loadgraph(io::IO, ::EdgeListFormat) = loadedgelist(io)
loadgraph(gname::String, ::EdgeListFormat) = loadedgelist(gname)

function create_node_map(graph_file)
    G, node_map = loadgraph(graph_file, EdgeListFormat())
    df = DataFrame(original_id = [keys(node_map)...], julia_id = [values(node_map)...])
    save_file = splitext(graph_file)[1] * "-nodemap.csv"
    CSV.write(save_file, df)
end

end