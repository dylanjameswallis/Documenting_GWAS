#creats .bai with samtools

samtools index -b aligntest_pair_sorted.bam #index sorted bam file for GATK
samtools faidx Danio_rerio.GRCz11.dna.primary_assembly.fa # index reference
