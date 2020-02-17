clear 
clc
[~, ~, OriginPlayerID] = xlsread('F_pageRank_1.xlsx','Sheet1','A1:A10549');
OriginPlayerID(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),OriginPlayerID)) = {''};


[~, ~, DestinationPlayerID] = xlsread('F_pageRank_1.xlsx','Sheet1','B1:B10549');
DestinationPlayerID(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),DestinationPlayerID)) = {''};


figure('NumberTitle', 'off', 'Name', 'Team members link graph');

Destination = DestinationPlayerID';
Origin = OriginPlayerID';
Graph = digraph(Origin,Destination);
p = plot(Graph,'Layout','layered','NodeColor',[0.93 0.78 0]);

pr = centrality(Graph,'pagerank','FollowProbability',0.85);
Graph.Nodes.PageRank = pr;
Graph.Nodes.InDegree = indegree(Graph);
Graph.Nodes.OutDegree = outdegree(Graph);
GraphTable = Graph.Nodes;
writetable(GraphTable,'.\out\F_pageRank_out.csv','Delimiter',',');

H = subgraph(Graph,find(Graph.Nodes.PageRank > 0));
plot(H,'NodeCData',H.Nodes.PageRank,'Layout','layered','markersize',8);
set(gca,'fontsize',20);
set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
legend('Team mate score')
colorbar

