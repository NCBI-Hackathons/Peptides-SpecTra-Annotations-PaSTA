# Peptides SpecTra Annotations (PaSTA)

## Background
Unlike the genomics field, currently most tools/workflows for analyzing proteomics data are either tied to a specific platform, such as Galaxy, or an operating system (OS), such as Microsoft 
Windows or Linux.  This lack of publicly available, non-platform/OS-dependent and reusable proteomics tools and workflows is preventing valuable public proteomic datasets, such as those in 
NCI’s [Proteomic Data Commons](), to be analyzed.  This proposal is to create an analysis workflow to generate annotated peptide sequence from proteomic spectra using containerized tools.


## Challenges in the field

TBD

## Workflow
![Peptides SpecTra Annotations (PaSTA)](flow.png)

## Prerequisite

- Java
- [ms-gf](https://omics.pnl.gov/software/ms-gf) v2017.01.13

## Installation

### Download the git repo

``` shell
git clone https://github.com/NCBI-Hackathons/Peptides-SpecTra-Annotations-PaSTA
cd Peptides-SpecTra-Annotations-PaSTA
```

### Install Percolator
``` shell
wget https://github.com/percolator/percolator/releases/download/rel-3-02-01/ubuntu64.tar.gz`
tar -xvzf ubuntu64.tar.gz
sudo dpkg -i *.deb
sudo apt-get install -f
```

### Installl Mimic

``` shell
sudo apt-get install cmake
git clone https://github.com/percolator/mimic.git
cd src
cmake -DCMAKE_INSTALL_PREFIX=/tmp/install . && make && make install
```

## Docker Instructions (under development)

A Docker image for the tools in the workflow is avialable here.  The image includes all the prerequisites and dependencies.  
To run the Docker image - 

Docker stuff goes here...

## Presentations

- [Day 1](https://docs.google.com/presentation/d/147Zc5lRd3Z88NPPw3sXfVm7SiB_dCZIF6JZnVzG_pJU/edit?usp=sharing)
- [Day 2](https://docs.google.com/presentation/d/1ND4Cnr6sN9k4f0hoWJ7APOw7Lo6x2yM-hDTkRCNlyWo/edit?usp=sharing)

## Future development

- Downstream analysis: http://meme-suite.org/
- Run the whole pipeline in a Docker image
