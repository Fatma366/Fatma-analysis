# Import the Pandas library
import pandas as pd

# Store the data in lists
index=[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
age=[21, 22, 23, 24, 25, 25, 26, 27, "28", 29]
height = [180, 170, "", 175, 190, 190, 195, 200, 205, 210]
weight = [70, 65, "80", 75, 90, 90, 95, 100, 105, 110]

# Store all the lists into a dictionary
dataset = {'id': id, 'age': age,'height': height,'weight':weight}

# Convert the dictionary into the Pandas Dataframe
df = pd.DataFrame(dataset)
print("Dataframe from dictionary:")

# Removing id column that is redundant
df.drop([],inplace=True,axis=1)

# Cleaning the dataset by converting all strings to intergers
df['age'] = df['age'].astype(int)
df['weight'] = df['weight'].astype(int)

# Filling empty fields in the height column
df = df.replace("", 190, regex=True)

# Removing Duplicates using drop_duplicates()
df.drop_duplicates(inplace = True)

# Reset the index
df = df.reset_index(drop=True)

def summary_statistics(dataframe, column_name):
    weight = dataframe[column_name].tolist()
    weight.sort()
    n = len(weight)
    
    #calculate the mean
    mean = sum(weight) / n
    
    #calculate the median
    if n % 2 ==0:
        median = (weight[n//2 - 1] + weight[n//2]) / 2
    else:
        median = weight[n//2]
        
    #calculate the standard deviation
    squared_differences = [(x - mean)**2 for x in weight]
    variance = sum(squared_differences) / n
    standard_deviation = variance**0.5
    
    return (mean, median, standard_deviation)

weight_summary =summary_statistics(df,'weight')
print(weight_summary)
