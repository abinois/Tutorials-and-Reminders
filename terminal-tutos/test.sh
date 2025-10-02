#!/bin/zsh

# Comment
echo Welcome !

# Get the exit code of the previous command. 0 is success
echo "Last command exit code: $?"
# Get the process ID of the current script
echo "Process ID of this script: $$"

# Assignment
name="John" # * no spaces around '='
two_words="$name Smith" # always put "" around to manage spaces in value
n=3
home=$(pwd) # result of command assigned to a variable : command substitution
current_dir=$(basename $(pwd)) # nested command substitution
empty_var=

# Variable access
echo "Hello $name, do you want $n cookies?" # * '$' to access variable value
echo "Empty var: >>$empty_var<<" # * empty variable is an empty string
echo "${name}athan and $two_words" # * {} around to avoid ambiguity and "" around to manage spaces in value
echo "Undefined: $undefined" # * Undefined variables do not cause error
echo 'We are here: $(pwd)' # * single quotes prevent command substitution
echo "We are here: $(pwd)" # * double quotes handles command substitution
echo "$name likes \$\$\$!" # * Escape special characters

# if statement
if [ $name = "John" ]; then # * spaces around '=' and spaces inside [ ... ]
	echo "Inside if statement"
fi



# Redicrection
ls -1 | wc -l # * | redirects result of the first command as input for the second one
line_number=$(ls -1 | wc -l | sed "s/ //g")
echo "There are "$line_number" files in "$current_dir"."
set | grep name=
echo "Current directory name is \"$(pwd | sed -r "s#.+/##g")\"."

# Function
my_function() {
	ls
	ls|wc -l
}
# my_function()
