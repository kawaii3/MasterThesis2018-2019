library(PlackettLuce)



example("beans", package = "PlackettLuce")
G<- grouped_rankings(R, rep(seq_len(nrow(beans)),4))
format(head(G,2),width = 50)

beans$year <- factor(beans$year)
tree <- pltree(G ~., data = beans[c("season", "year", "maxTN")],
               minsize = 0.05*n, maxdepth = 3)
tree

plot(tree, names = FALSE, abbreviate = 2)

png("tree.png")
dev.off()
