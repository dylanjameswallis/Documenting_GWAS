for file in $(ls .); do awk 'NR==1{$0=$0"|"FILENAME}1' $file; done >> allsox7.fa

