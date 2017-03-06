#!/usr/bin/env Rscript


tumors=paste0(c(3,11,13,15,17,25,29,33,37,41),"A")
normals=paste0(c(3,11,13,15,17,25,29,33,37,41)+1,"A")
#normals=c('2A','4A','6A','8A','10A','12A')
#tumors=c('1A','3A','5A','7A','9A','11A')

chrlen=c(249250621,243199373,198022430,191154276,180915260,171115067,159138663,146364022,141213431,135534747,135006516,133851895,115169878,
         107349540,102531392,90354753,81195210,78077248,59128983,63025520,48129895,51304566,155270560,59373566
)
chrstart=rep(0,length(chrlen))
for (i in 1:(length(chrlen)-1))
{
  
  chrstart[i+1]=chrstart[i]+chrlen[i]
}

chrs=c(paste0("chr",c(1:22)),"chrX","chrY")

plotbam=function(bamtable,opt,outfig)
{
  readlen=150
  windowsize=10000
  threshold=5*windowsize/readlen #coverage>5
  if (opt==1) #normal
  {
    tmptable=bamtable[,c((1:3),4)]
  }else #tumor
  {
    tmptable=bamtable[,c((1:3),5)]
  }
  tmptable=tmptable[tmptable[,4]>=threshold,]
  coveragetable=tmptable
  coveragetable[,4]=tmptable[,4]*readlen/windowsize
  print(paste0("mean coverage=",mean(coveragetable[,4])))
  color2<-rep(c("gray33","brown","darkgreen","aquamarine4","azure4","darkred","cyan4","chartreuse4",
                "cornflowerblue","darkblue","azure3","darkgray","cadetblue","deepskyblue4"),2)
  colors=rep(NA,nrow(tmptable))
  for (chrid in 1:length(chrs))
  {
    chr=chrs[chrid]
    chridx=which(tmptable[,1]==chr)
    coveragetable[chridx,c(2,3)]=tmptable[chridx,c(2:3)]+chrstart[chrid]
    colors[chridx]=color2[chrid]
  }
  xmin=1
  xmax=coveragetable[nrow(coveragetable),3]
  ymin=1
  ymax=100
  png(outfig, width = 12, height = 8, units = 'in', res=300)
  tmp=par("mar")
  par(mar=tmp+c(0,1.5,0,0))
  plot(c(xmin,xmax),c(ymin,ymax),type="n",xlab='coordinate',ylab='depth of coverage',xaxt = 'n',cex.lab=1.5,cex.axis=2)
  points(coveragetable[,2],coveragetable[,4],col=colors)
  library(scales)
  arrows(coveragetable[,2],0,coveragetable[,2],coveragetable[,4], length=0, col=alpha(colors, 0.2))
  xlabidx=c(1,3,5,7,9,11,13,15,19,22) #sel chrs on xlab
  xlabpos=chrstart[xlabidx]+chrlen[xlabidx]/2
  xlabels=chrs[xlabidx]
  axis(1,at=xlabpos,labels = xlabels,cex.axis=1.5)
  dev.off()
}

opt=2
for (numpair in 1:length(normals))
{
  tumor=tumors[numpair]
  bamcrfile=paste0(tumor,".merged.deduprealigned.bam.10000.crq1.txt")
  bamtable=read.table(bamcrfile,header=T,sep="\t")
  if (opt==1)
  {
    outfig=paste0(normals[numpair],".q1coverage.png")
  }else
  {
    outfig=paste0(tumor,".q1coverage.png")
  }
  plotbam(bamtable,opt,outfig)
}