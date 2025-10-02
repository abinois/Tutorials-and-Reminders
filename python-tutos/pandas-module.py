import pandas as pd
import numpy as np

# * Documentaion : https://pandas.pydata.org/docs/user_guide/index.html

#* ======== IMPORT ========
# df = pd.read_csv('file.csv')				# Read a csv file and conver into a dataframe
# df = pd.read_json('file.json')			# Read a json file and conver into a dataframe
# df = pd.read_excel('file.xlsx')			# Read a excel file and conver into a dataframe

#* ======== CREATE ========
s = pd.Series([1, 3, 5, np.nan, 6, 8]) 		# Create a Series object
d = pd.DataFrame(							# Create a DataFrame object
    {
        "A": 1.0,
        "B": pd.Timestamp("20130102"),
        "C": pd.Series(1, index=list(range(4)), dtype="float32"),
        "D": np.array([3] * 4, dtype="int32"),
        "E": pd.Categorical(["test", "train", "test", "train"]),
        "F": "foo",
    }
)

def regene() -> pd.DataFrame:
	"""Generate and return a Dataframe object for example purposes."""
	return pd.DataFrame({
		'Name': ['Patric', 'Rose', 'Lily', 'Bernardt', 'Stevo', 'Natasha', 'Jack', 'Paul', 'Bob', 'Hannah', 'Billie', 'Jane'],
		'Age': [45, 76, 3, 39, 29, 51, 6, 42, 17, 23, 36, 18],
		'Grade': [5, 6, 14, 19, 0, 15, 7, 2, 10, 16, 14, 12],
		'ID': [233, 467, 189, 34, 68, 475, 234, 145, 889, 90, 123, 568],
		'City': ['Rouen', 'Lille', 'Marseille', 'Paris', 'Paris', 'Lille', 'Oslo', 'New York', 'Lille', 'Rio', 'Brest', 'Boston'],
		'Availability': [True, True, False, True, False, False, True, True, False, True, False, False]
	})
df = regene()
print(df)

#* ======== DISPLAY FUNCTION ========
# from IPython.display import display
# display(df)								# Display in interactive mode
df.head()									# Return a df containing the 5 first lines
df.tail()									# Return a df the 5 last lines
df.describe()								# shows a quick statistic summary of your data

#* ======== ATTRIBUTE ========
print('-'*60)
print("Shape:", df.shape)					# return a tuple -> (row_number, column_number)
print("Indexes:", df.index)					# dataframe indexes
print("Columns:", df.columns)				# dataframe column names
df.dtypes									# return a Series object containing the types of each column
array = df.values							# return a numpy array version of the dataframe
# print("Line at index 1:", array[1,:])
# print("Column at index 3:", array[:,3])
# print("Lines with grade < 10\n", array[array[:,2] < 10])
# print("Lines with city = Paris\n", array[array[:,-2] == 'Paris'])
df.T										# transpose : swap dimensions

#* ======== COLUMN ACCESS ========
# Access 1 column with string
df['Name'] 									# Return a Series object
df.Name										# Equivalent to previous
# Access multiple columns with list
df[['City', 'Availability', 'Age']] 		# Return a DataFrame object. It will keep the given column names order
# df.loc()									# 
# df.iloc()									# 
# df.at()									# 
# df.iat()									# 


#* ======== COLUMN MODIFICATION ========
print('-'*60)
# --- Modify column with a fixed value. Modifies the dtype as well
df['Name'] = -5								# Replace all the values of a column by a fixed value
# --- Modify column with a python list, a numpy array or a pandas series of the same size of the column
df['City'] = ['Hell'] * df.shape[0]			# Replace all values by 'Hell'
df['Grade'] = df['Grade'] * 100				# Replace all values by themselves multiplied by 100
df['Age'] = np.random.randint(1, 1000, df.shape[0]) 	# Replace all values by a random number between 1 and 1000
# --- Create new column
df['Contact'] = ['0612345678'] * df.shape[0]
# --- Delete column : 3 options
df = df.drop(columns='ID')					# df.drop() doesnt modify the original Dataframe
# df.pop('ID')								# Returns the deleted Series
# del df['ID']								# Deletes the column
# --- Rename column
df.rename(columns={'City': 'Localastion', 'Grade': 'Score'}, inplace=True)
# --- Change dtype of a column
df['Score'] = df['Score'].astype(float)

print(df.head())
df = regene()

#* ======== SORT ========
# df.sort_index(axis=1, ascending=False)
# df.sort_values(by="Grade")
# df.sort_values(['Age', 'Score']) # Sort by Age, then by score
# df.sort_values(['Age', 'Score'], ascending=[True, False]) # Same as previous but sort by Score will be unascending