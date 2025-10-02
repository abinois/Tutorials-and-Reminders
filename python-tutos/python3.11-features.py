
# * ---------------------- Positional only
def f(a, /, b):
    print(f"{a=}, {b=}")

f(1, 2)
f(1, b=2)
# f(a=1, b=2)
# f(b=1, a=2)

# * ----------------------- Dict update operator
a = {
    "toto" : True,
    "tata" : False,
    "titi" : 0      # Exclusive key
}
b = {
    "toto" : False, # Diff value
    "tata" : False, # Same value
    "tutu" : []     # New key
}
print(a | b)
print(b | a)
a |= b #  auto assigning
print(a)