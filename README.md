# JGI_downloader
Download files from JGI
Now only for PhytozomeV12

## Needs to change username and password in script before using.

# Usage:
## 1. generate download scripts:
  JGI_downloader.pl > run.sh

## 2. start to download
  sh run.sh

## or download in parallel
  cat run.sh | parallel -j 6

