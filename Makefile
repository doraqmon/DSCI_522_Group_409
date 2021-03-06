# Make file for Group409: Bike Sharing Machine Learning Model
# Aman Kumar Garg, Victor Cuspinera-Contreras, Yingping Qian
# January 30, 2020
# 
# This driver script completes the explanatory data analysis and
# fitting machine learning model for bike sharing dataset. It will 
# creats 5 figures and 1 tables used in the report and generates 
# html and md versions of the report. This script takes no arguments. 
# 
# usage: make all  
#							to run all the analysis
# usage: make clean 
#							to clean up all the intermediate and results files

# run all analysis and generate the html and md versions of report
all: doc/bike_sharing_ml_model.md doc/bike_sharing_ml_model.html

# download data from the link
data/hour.csv : src/data_download.py
	python src/data_download.py --file_url="https://archive.ics.uci.edu/ml/machine-learning-databases/00275/Bike-Sharing-Dataset.zip" --file_path="data/"

# pre-process data and split into training and test sets
data/training_data.csv data/test_data.csv : data/hour.csv src/data_wrangling.r
	Rscript src/data_wrangling.r --input="data/hour.csv" --out_dir="data/"

# create exploratory data analysis figure and write to file 
img/fig_2b_workingday.png img/fig_3_hr.png img/fig_5_corr.png: data/training_data.csv src/EDA.py
	python src/EDA.py --input_file="data/training_data.csv" --output_path="img/"

# tune and test the model, generates figures and final results
result/feature_importance.png result/fig_result.png result/result.csv : data/training_data.csv data/test_data.csv src/data_modelling.py
	python src/data_modelling.py --input_file_path="data/" --output_file_path="result/"

# render report	into html and md versions
doc/bike_sharing_ml_model.md doc/bike_sharing_ml_model.html : img/fig_2b_workingday.png img/fig_3_hr.png img/fig_5_corr.png result/feature_importance.png result/fig_result.png result/result.csv
	Rscript -e "rmarkdown::render('doc/bike_sharing_ml_model.Rmd', output_format = 'github_document')"
	
# Clean up intermediate and results files
clean : 
	rm -f data/*.csv 
	rm -f data/*.txt
	rm -f img/*.png
	rm -f img/*.csv
	rm -f img/*.txt
	rm -f result/*.png
	rm -f result/*.csv
	rm -f doc/*.md
	rm -f doc/*.html