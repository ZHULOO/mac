# python环境下运行stata
# 安装stata_setup模块:pip install stata_setup
import stata_setup
stata_setup.config("C:/Program Files/Stata17", "mp")

# Import the json file into a Python dataframe
import os
import json
import pandas as pd
os.getcwd()
os.chdir("E:/MyGit/python/stata")
with open("did.json") as json_file:
    data = json.load(json_file)
data = pd.json_normalize(data, 'records', ['hospital_id', 'month'])
data

# Load data to Stata
from pystata import stata
stata.pdataframe_to_data(data, True)

# Run block of Stata code 
stata.run('''
destring satisfaction_score, replace
destring hospital_id, replace
destring month, replace

gen proc = 0
replace proc = 1 if procedure == "New"
label define procedure 0 "Old" 1 "New"
drop procedure
rename proc procedure
label value procedure procedure
''')

stata.run('''
didregress (satisfaction_score) (procedure), group(hospital_id) time(month)
''', echo=True)

# Load Stata results to Python
r = stata.get_return()['r(table)']

# Use Stata results in Python
print("The treatment hospitals had a %4.2f-point increase." 
    % (r[0][0]), end=" ") 
print("The result is with 95%% confidence interval [%4.2f, %4.2f]." 
    % (r[4][0], r[5][0]))

# Generate Stata graph 
stata.run("estat trendplots")
stata.run("graph export did.svg, replace")
