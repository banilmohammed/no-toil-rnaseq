# Pipelines Sample Run No-Toil RNASeq

Server/Computer: courtyard

Login ID: nmohamm5

Time: 2022.06.08

Clone pipelines repo.

```
git clone https://github.com/UCSC-Treehouse/pipelines.git
```

Navigate to pipelines repo and make. Fusion output results do not matter at this stage.

```
cd piplines
make
.
.
.
Verifying md5 of output of TEST file
tar -xOzvf outputs/expression/TEST_R1merged.tar.gz TEST_R1merged/RSEM/rsem_genes.results | md5sum -c md5/expression.md5
TEST_R1merged/RSEM/rsem_genes.results
-: OK
cut -f 1 outputs/fusions/star-fusion-non-filtered.final | sort | md5sum -c md5/fusions.md5
cut: outputs/fusions/star-fusion-non-filtered.final: No such file or directory
-: FAILED
md5sum: WARNING: 1 computed checksum did NOT match
make: *** [Makefile:119: verify] Error 1
```

Naviate to no-toil rnaseq dir and build docker image.

```
docker build -t notoil_rnaseq:latest .
```

Download RSEM, STAR references, and move test data to /data.

```
mv ../piplines/samples/* /data/
wget http://courtyard.gi.ucsc.edu/~jvivian/toil-rnaseq-inputs/continuous_integration/rsem_ref_chr6.tar.gz
wget http://courtyard.gi.ucsc.edu/~jvivian/toil-rnaseq-inputs/continuous_integration/starIndex_chr6.tar.gz
tar -xzvf rsem_ref_chr6.tar.gz
tar -xzvf starIndex_chr6.tar.gz
```

Make star output dir within /data.

```
mkdir star
```

Run docker image.

```
docker run --rm -v /mnt/notoil_rnaseq/data/:/data rnaseq:latest
```

Compare results.

```
diff rsem.genes.results /mnt/pipelines/outputs/expression/TEST_R1merged/RSEM/rsem_genes.results
```

Diff showed no differences.
