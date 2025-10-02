reset   = "\033[0m"
black   = "\033[30m"
red     = "\033[31m"
green   = "\033[32m"
yellow  = "\033[33m"
blue    = "\033[34m"
magenta = "\033[35m"
cyan    = "\033[36m"
jungle  = "\033[38;5;28m"
brown   = "\033[38;5;94m"
purple  = "\033[38;5;129m"
kaki    = "\033[38;5;143m"
sky     = "\033[38;5;159m"
pink    = "\033[38;5;206m"
orange  = "\033[38;5;208m"
grey    = "\033[38;5;248m"
#------ FX -------
bold    = "\033[1m"
hollow  = "\033[2m"
italic  = "\033[3m"
under   = "\033[4m"
blink   = "\033[5m"
rev     = "\033[7m"
hide    = "\033[8m"
over    = "\033[9m"

def print_dic(dic, marge=''):
    print(green + marge + '{' + reset)
    for k, v in dic.items():
        print(marge + green, k, reset + ':')
        print_info(v, marge=marge + '\t')
    print(green + marge + '}' + reset)

def print_list(liste, marge=''):
    print(pink + marge + '[' + reset)
    for elem in liste:
        print_info(elem, marge=marge + '\t')
    print(pink + marge + ']' + reset)

def print_tuple(tupl, marge=''):
    print(blue + marge + '(' + reset)
    for elem in tupl:
        print_info(elem, marge=marge + '\t')
    print(blue + marge + ')' + reset)

def print_set(a_set, marge=''):
    print(kaki + marge + '{' + reset)
    for elem in a_set:
        print_info(elem, marge=marge + '\t')
    print(kaki + marge + '}' + reset)

def print_bool(boolean, marge=''):
    print(cyan + marge, boolean, reset, sep='')

def print_str(string, marge=''):
    print(yellow + marge + string + reset)

def print_int(integer, marge=''):
    print(orange + marge, integer, reset, sep='')

def print_float(floater, marge=''):
    print(purple + marge, floater, reset, sep='')

def print_type(type_of, marge=''):
    print(magenta + marge, type_of, reset, sep='')

def print_object(obj, marge=''):
    print(red + marge, obj, reset, sep='')

def print_none(null, marge=''):
    print(grey + marge, null, reset, sep='')

def print_other(other, marge=''):
    print(brown + marge, other, reset, sep='')

type_ref = {
    list            : print_list,
    dict            : print_dic,
    bool            : print_bool,
    str             : print_str,
    int             : print_int,
    float           : print_float,
    frozenset       : print_set,
    set             : print_set,
    tuple           : print_tuple,
    type            : print_type,
    object          : print_object,
    type(None)      : print_none,
    range           : print_tuple
}

def print_info(info, marge=''):
    if type(info) in type_ref:
        type_ref[type(info)](info, marge=marge)
    else:
        print_other(info, marge=marge)

if __name__ == "__main__":
    info =  {
        'string'    : 'Hello',
        'int'       : 0,
        'float'     : 0.0,
        'bool'      : False,
        'None'      : None,
        'objet'     : object(),
        'type'      : type,
        'tuple'     : tuple(),
        'range'     : range(0),
        'set'       : set(),
        'frozenset' : frozenset(),
        'list'      : list(),
        'dict'      : dict(),
            }
    print_info(info)