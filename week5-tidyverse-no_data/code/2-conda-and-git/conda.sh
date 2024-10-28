# This script contains commands for setting up and saving a Conda environment

conda create -n ahds_formative

conda activate ahds_formative

conda install r-base=4.4.1 r-tidyverse=2.0.0 r-janitor=2.2.0

conda export --from-history >../../ahds_formative_environment.yml
