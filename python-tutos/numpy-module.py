import numpy as np

# * documentation : https://numpy.org/doc/stable/

x = [-2, -1, 1, 2]

# * ---- METHODS -----
np.mean(x)			# Moyenne
np.abs(x)			# Valeur aboslue
np.exp(x)			# Exponentielle
np.log(np.abs(x))	# Logarithme
np.sin()			# Sinus
np.sqrt()			# Racine carré

# * ----- CREATE -----
a = np.array([[-2, -1, 1, 2], [1, 2, 3, 4]]) # from python list
np.zeros(5)				# crée un array rempli de 0, de 5 éléments
np.ones(5)				# crée un array rempli de 1, de 5 éléments
np.empty(5)				# crée un array vide de 5 éléments
np.arange(0, 10, 2)		# crée un array rempli avec une séquence linéaire, qui ira de 0 à 10, par pas de 2
np.linspace(0, 10, 5)	# crée un array de 5 valeurs espacées uniformément entre 0 et 10
np.ones(2, dtype=np.int64) # specify datatype / default is np.float64

# * ----- SAVE/LOAD -----
np.save('filename', a) # save it as “filename.npy”
a = np.load('filename.npy') # use np.load() to reconstruct your array.
np.savetxt('new_file.csv', a) # save it as a .csv file
np.loadtxt('new_file.csv')

# * ----- ATTR -----
a.dtype		# return value type -> numpy arrays can only contain 1 type of values
a.shape		# return tuple specifying the number of elements along each dimension
a.ndim		# return number of dimensions for the array
a.size		# return total number of elements in the array

# * ----- SORT -----
np.sort(a)
# argsort		-> which is an indirect sort along a specified axis
# lexsort		-> which is an indirect stable sort on multiple keys
# searchsorted	-> which will find elements in a sorted array
# partition		-> which is a partial sort

# * ----- RESHAPE -----
a = np.array([1, 2, 3, 4, 5, 6])
a.reshape(3, 2)
np.reshape(a, shape=(1, 6), order='C')
# 1 dimension to 2 dimensions :
a2 = a[np.newaxis, :] # You can use np.newaxis to add a new axis
# add a dimnension :
b = np.expand_dims(a, axis=1) # You can use np.expand_dims to add an axis at index position 1

# You can also use .transpose() to reverse or change the axes
arr = np.arange(6).reshape((2, 3))
# array([[0, 1, 2],
#        [3, 4, 5]])
arr.transpose() # You can also use arr.T
# array([[0, 3],
#        [1, 4],
#        [2, 5]])

np.flip(a) # flip, or reverse, the contents of an array along an axis.
# You can easily reverse only the rows with:
reversed_arr_rows = np.flip(a, axis=0)
# [[ 9 10 11 12]
#  [ 5  6  7  8]
#  [ 1  2  3  4]]
# You can reverse the second row:
a[1] = np.flip(a[1])
# [[ 1  2  3  4]
#  [ 8  7  6  5]
#  [ 9 10 11 12]]
# You can also reverse the second column:
a[:,1] = np.flip(a[:,1])
# [[ 1 10  3  4]
#  [ 8  7  6  5]
#  [ 9  2 11 12]]

# You can use flatten to flatten your array into a 1D array.
x = np.array([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]])
x.flatten()
# array([ 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12])

# * ----- CONCATENATE -----
a = np.array([1, 2, 3, 4])
b = np.array([5, 6, 7, 8])
np.concatenate((a, b))

a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6]])
np.concatenate((a, b), axis=0)
# array([[1, 2],
#        [3, 4],
#        [5, 6]])

a1 = np.array([[1, 1], [2, 2]])
a2 = np.array([[3, 3], [4, 4]])
np.vstack((a1, a2)) # vertically
# array([[1, 1],
#        [2, 2],
#        [3, 3],
#        [4, 4]])

np.hstack((a1, a2)) # horizontally
# array([[1, 1, 3, 3],
#        [2, 2, 4, 4]])

# * ----- OPERATIONS -----
data = np.array([1, 2])
ones = np.ones(2, dtype=int)
data + ones	# -> array([2, 3])
data - ones	# -> array([0, 1])
data * data	# -> array([1, 4])
data / data	# -> array([1., 1.])
data @ ones	# calcul matriciel

data = np.array([1.0, 2.0])
data * 1.6 	# -> array([1.6, 3.2]) (multiplication)
data ** 2.0	# -> array([1.0, 4.0]) (puissance)
data.max()	# 2.0
data.min()	# 1.0  | a.min(axis=0) -> specify the axis
a.argmin()	# accéder à l’indice de l’élement minimum
a.argmax()
data.sum()	# 3.0
b = np.array([[1, 1], [2, 2]])
# You can sum over the axis of rows with:
b.sum(axis=0) # -> array([3, 3])
# You can sum over the axis of columns with:
b.sum(axis=1) # -> array([2, 4])

# * ----- FILTER -----
a < 4 # return an array of bool. It's equivalent to : [ x < 4 for x in lst ]
a[a < 4] # return a filtered array with elements matching the condition
a[(a < 4) & (a > 1)] # same with multiple conditions
a[(a < 4) | (a > 1)] # same with multiple conditions

five_up = (a >= 5) # store condition in a variable and use it to filter the array
a[five_up]

# - - np.nonzero()
a = np.array([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]])
b = np.nonzero(a < 5) #You can use np.nonzero() to print the indices of elements that are, for example, less than 5
# (array([0, 0, 0, 0]), array([0, 1, 2, 3]))
# In this example, a tuple of arrays was returned: one for each dimension.
# The first array represents the row indices where these values are found,
# and the second array represents the column indices where the values are found.

# If you want to generate a list of coordinates where the elements exist,
# you can zip the arrays, iterate over the list of coordinates, and print them:
list_of_coordinates= list(zip(b[0], b[1]))
for coord in list_of_coordinates:
    print(coord)
# (np.int64(0), np.int64(0))
# (np.int64(0), np.int64(1))
# (np.int64(0), np.int64(2))
# (np.int64(0), np.int64(3))

# You can also use np.nonzero() to print the elements in an array that are less than 5 with:
print(a[b])
# [1 2 3 4]

# * ----- SLICE -----
data = np.array([[1, 2], [3, 4], [5, 6]])
# array([[1, 2],
#        [3, 4],
#        [5, 6]])
data[0, 1]
# 2
data[1:3]
# array([[3, 4],
#        [5, 6]])
data[0:2, 0]
# array([1, 3])
# Slicing will return a view, whenever possible, to save memory.
# ! However it’s important to be aware that modifying data in a view also modifies the original array!

# * ----- SPLIT -----
# - - np.hsplit()
x = np.arange(1, 25).reshape(2, 12)
# array([[ 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12],
#        [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]])

# If you wanted to split this array into three equally shaped arrays:
np.hsplit(x, 3)
#   [array([[ 1,  2,  3,  4],
#          [13, 14, 15, 16]]), array([[ 5,  6,  7,  8],
#          [17, 18, 19, 20]]), array([[ 9, 10, 11, 12],
#          [21, 22, 23, 24]])]

# If you wanted to split your array after the third and fourth column:
np.hsplit(x, (3, 4))
#   [array([[ 1,  2,  3],
#          [13, 14, 15]]), array([[ 4],
#          [16]]), array([[ 5,  6,  7,  8,  9, 10, 11, 12],
#          [17, 18, 19, 20, 21, 22, 23, 24]])]
