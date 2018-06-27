#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import print_function
from optparse import OptionParser
import re,sys,os

#*********************************************************************** 青年才俊红凡凡 *********************************************************************************
#argument:
usage = '%prog -[i]'
p = OptionParser(usage = usage)
p.add_option('-i', '--input', dest = 'input', metavar = '*.absoult.xls',
			help = 'taxonomic count data file')
p.add_option('-o', '--output', dest = 'output', metavar = '*.rda.pdf', default = 'rda.pdf',
			help = 'given an output file name, default is rda.pdf')
p.add_option('-g', '--group', dest = 'group', metavar = 'group',
			help = 'annotate the points with the same color from this group file')
p.add_option('-e', '--env', dest = 'env', metavar = 'env.list',
			help = 'environment parameter file')
p.add_option('-n', '--number', dest = 'number', metavar = '15', default = '15',
			help = 'specify how many species to be display, defaulf is 15')
p.add_option('--leg', dest = 'leg', metavar = 'topright/bottomleft', default = 'bottomright',
			help = 'the location of the legend for species, default is bottomright')
p.add_option('--text', dest = 'text', metavar = 'T or F', default = 'T',
			help = 'points this sample names or not. default is yes')
p.add_option('--width', dest = 'width', default = '10',
			help='the width of the graphics region in inches.  The default values are 10')
p.add_option('--height', dest = 'height', default = '8',
			help='the height of the graphics region in inches.  The default values are 8')
(options,args) = p.parse_args()

if not options.input and options.group:
	p.error("must have argument -i")
	sys.exit()
elif options.text != 'T' and options.text != 'F':
	p.error("argument --text value must be 'T' or 'F'")
	sys.exit()
else:
	pass

#********************************************************************* I AM A LONELY LINE ********************************************************************************
#data file:
infile = open(options.input)
outfile = open('data.txt', 'w')

with open(options.group) as ingroup:
	rawsample = []
	for i in ingroup:
		isplit = i.rstrip().split('\t')
		if isplit[0] == 'sample' or isplit[0] == '#sample':
			pass
		else:
			if isplit[0] in rawsample:
				print ("repeat sample:'%s' has been found in group file" % isplit[0])
				sys.exit()
			else:
				rawsample.append(isplit[0])

spe = []
n = 1
for i in infile:
	isplit = re.split(r'\t', i.rstrip())
	if n == 1:
		title = isplit
		line = '\t' + '\t'.join(rawsample)
		print (line, file = outfile)
	else:
		if isplit[0] in spe:
			pass
		else:
			spe.append(isplit[0])
			line = isplit[0] + '\t'
			for a in rawsample:
				line += isplit[title.index(a)] + '\t'
			print (line.rstrip(), file = outfile)
	n += 1
infile.close()
outfile.close()

osplit = re.split(r'\.', options.output)
if osplit[0] == 'rda':
	main = 'Plot'
else:
	main = osplit[0]

#********************************************************************* I AM A LONELY LINE *******************************************************************************
#Rscript:
path = os.getcwd()
rscript = open('rda.R', 'w')

print ('''
library(vegan)

dat <- read.table("%s/data.txt", head = TRUE, row.names = 1, sep = "\\t")
envdata <- read.table("%s/%s", header = TRUE, row.names = 1, sep = "\\t")
groups <- read.table("%s/%s", header = TRUE, sep="\\t")

b <- matrix(0, nrow = nrow(dat), ncol = ncol(dat))
for(i in 1:ncol(dat)){
	b[,i] = dat[ ,i]
}
colnames(b) <- colnames(dat)
rownames(b) <- rownames(dat)
data <- t(b)
rownames(groups) <- groups$sample
cols <- c("red", "blue", "green", "purple", "cyan", "darkblue", "seagreen", "steelblue","DarkTurquoise", "Sienna", "Chocolate", "BlueViolet", "Magenta", "brown", "gray", "darkred", "pink", "orange", "palegreen", "Palevioletred", "DeepPink", "indianred")
pchs <- c(16, 15, 17, 18, 8, 4, 5, 1, 2, 6, 7, 3, 9, 10, 11, 12, 13, 14)
col <- rep("black", dim(data)[1])
pch <- rep(19, dim(data)[1])
group <- unique(groups$group)
for (i in 1:length(group)){
	pch[groups[rownames(data), 2] == group[i]] <- pchs[i]
	col[groups[rownames(data), 2] == group[i]] <- cols[i]
}

dca <- decorana(veg = data)
dcam <- max(dca$rproj)
if (dcam > 4){
	cca <- cca(data ~ ., envdata, scale = TRUE, na.action = na.exclude)
	pre <- "CCA"
}else{
	cca <- rda(data ~ ., envdata,scale = TRUE, na.action = na.exclude)
	pre <- "RDA"
}
ccascore <- scores(cca)
write.table(ccascore$sites, file = paste("%s/", pre, ".sample.xls", sep = ""), sep = "\\t")
write.table(ccascore$species, file = paste("%s/", pre, ".sp.xls", sep = ""), sep = "\\t")
envfit <- envfit(cca, envdata, permu = 2000, na.rm = TRUE)
rp <- cbind(as.matrix(envfit$vectors$r), as.matrix(envfit$vectors$pvals))
colnames(rp) <- c("r2", "Pr(>r)")
env <- cbind(envfit$vectors$arrows, rp)
write.table(as.data.frame(env), file = paste("%s/", pre, "envfit.xls", sep = ""),sep = "\\t")
CCAE1 <- as.numeric(env[, 1])
CCAE2 <- as.numeric(env[, 2])
CCAS1 <- as.numeric(ccascore$sites[, 1])
CCAS2 <- as.numeric(ccascore$sites[, 2])'''
% (path, path, options.env, path, options.group, path, path, path),
file = rscript)

if len(spe) <= int(options.number):
	num = len(spe)
	print ('CCASP1 = as.numeric(ccascore$species[, 1])\nCCASP2 = as.numeric(ccascore$species[, 2])', file = rscript)
else:
	num = int(options.number)
	print ('CCASP1 = as.numeric(ccascore$species[1:%s, 1])\nCCASP2 = as.numeric(ccascore$species[1:%s, 2])' % (options.number, options.number), file = rscript)

print ('''
pc1 = cca$CCA$eig[1]/sum(cca$CCA$eig) * 100
pc2 = cca$CCA$eig[2]/sum(cca$CCA$eig) * 100
xlab <- paste(pre, "1: ", round(pc1, digits = 2), "%%", sep = "")
ylab <- paste(pre, "2: ", round(pc2, digits = 2), "%%", sep = "")
main <- paste(pre, "-%s(", xlab, "; ", ylab, ")", sep = "")
rex <- c(CCAS1, CCASP1)
rey <- c(CCAS2, CCASP2)
x1 <- rex[order(rex)[1]] * 1.2
x2 <- rex[order(rex)[length(rex)]]  * 1.2
xlim <- c(x1, x2)
y1 <- rey[order(rey)[1]] * 1.2
y2 <- rey[order(rey)[length(rey)]] * 1.2
ylim <- c(y1, y2)
pdf("%s/%s", height = %s, width = %s)
layout(matrix(c(1,2),1,2),widths=c(3,1))
par(mar=c(4,4,2,0), oma=c(2,1,2,1))'''
% (main, path, options.output, options.height, options.width),
file = rscript)

#Graphics:
print ('''
matplot(
	CCAS1,
	CCAS2,
	xlab = xlab,
	ylab = ylab,
	xlim = xlim,
	ylim = ylim,
	main = main,
	type = "n",
	cex.lab = 0.8
	)
abline(v = 0, h = 0, lty = 3, col="grey")
points(
	CCAS1,
	CCAS2,
	col = col,
	bg = col,
	cex = 1.2,
	pch = pch
	)''',
file = rscript)

if options.text == 'T':
	print ('''
text <- rownames(ccascore$sites)
text(
	CCAS1,
	CCAS2,
	labels = text,
	cex = 1,
	col = col,
	font = 3,
	adj = c(-0.2,-0.2)
	)''',
file = rscript)
else:
	pass

print ('''
points(
	CCASP1,
	CCASP2,
	col = cols,
	cex = 1.2,
	pch = 3
	)
spe <- rownames(ccascore$species)[1:%s]
legend(
	x = "%s",
	legend = spe,
	col = cols,
	pch = 3,
	cex = 0.7,
	horiz = FALSE
	)
arrows(
	x0 = 0,
	y0 = 0,
	x1 = CCAE1,
	y1 = CCAE2,
	col = "black",
	lty = 1,
	lwd = 1.2,
	length = 0.15
	)
envir <- rownames(env)
text(
	CCAE1,
	CCAE2,
	labels = envir,
	cex = 0.8,
	col = "black",
	font = 3,
	adj = c(-0.2,-0.2)
	)
barplot(
	x2,
	axes = FALSE,
	col = "white",
	border = NA,
	axisnames = FALSE
	)
legend(
	"left",
	legend = group,
	col = cols,
	pt.bg = cols,
	text.col = cols,
	pch = pchs,
	horiz = FALSE,
	bty = 'n',
	cex = 1
	)
dev.off()'''
% (num, options.leg),
file = rscript)

rscript.close()

#os.system('/System/Pipline/DNA/DNA_Micro/16S_pipeline/16S_pipeline_V1.10/software/R-3.1.0/bin/Rscript rda.R')
os.system('Rscript rda.R')
