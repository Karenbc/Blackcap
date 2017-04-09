## load scaffold positions (from genome/09_process_satsuma.sh)

scafs <- read.csv("~/blackcaps/genome/data/blackcap_scafs_ordered_by_fly.csv")
scafs$id <- 1:nrow(scafs)
scafs$black_scaf <- gsub("Q","",scafs$black_scaf)

## load scaffold data

win <- "5000"
pbs_files <- list.files (pattern = paste(win,"_summary_pbs.txt",sep=""))

for (i in seq_along(pbs_files)) {
  if (i ==1) {
    pbs.dat <- read.table(pbs_files[i],header=TRUE)
  } else {
    dat <- read.table(pbs_files[i],header=TRUE)
    pbs.dat <- rbind(pbs.dat,dat)
  }
}

## id flycatcher chr, order along that chr and include orientation for each blackcap scaffold
pbs.dat$best_fly_chr <- as.character(NA)
pbs.dat$best_fly_id <- as.numeric(0)
pbs.dat$orientation <- as.character(NA)

for (i in 1:length(pbs.dat$chr)){
  for (j in 1:length(scafs$best_fly_chr)){
    
    if (pbs.dat$chr[i] == scafs$black_scaf[j]){
      pbs.dat$best_fly_chr[i] <- as.character(scafs$best_fly_chr[j])
      pbs.dat$best_fly_id[i] <- as.numeric(scafs$id[j])
      pbs.dat$orientation[i] <- as.character(scafs$ori[j])
    }
  }
}

save(pbs.dat,file=paste("pbs_",win,"combined_ordered_ancestral.R",sep=""))
save(pbs.dat,file=paste("pbs_",win,"combined_ordered_short.R",sep=""))
save(pbs.dat,file=paste("pbs_",win,"combined_ordered_island.R",sep=""))
