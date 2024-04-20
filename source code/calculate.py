UNSIGNED_BOUND_NUMBER = 2**256 - 1
UNSIGNED_MOD_NUMBER = 2**256

def compute(operator,*args):
    if operator == "EQ":
        return compute_EQ(args[0],args[1])
    elif operator == "EXP":
        return compute_EXP(args[0],args[1])
    elif operator == "NOT":
        return compute_NOT(args[0])
    elif operator == "OR":
        return compute_OR(args[0],args[1])
    elif operator == "AND":
        return compute_AND(args[0],args[1])
    elif operator == "NOT":
        return compute_NOT(args[0])
    elif operator == "MUL":
        return compute_MUL(args[0],args[1])
    elif operator == "ADD":
        return compute_ADD(args[0],args[1])
    elif operator == "SUB":
        return compute_SUB(args[0],args[1])
    elif operator == "DIV":
        return compute_DIV(args[0],args[1])
    elif operator == "XOR":
        return compute_XOR(args[0],args[1])
    elif operator == "SHL":
        return compute_SHL(args[0],args[1])
    elif operator == "SHR":
        return compute_SHR(args[0],args[1])
    elif operator == "LT":
        return compute_LT(args[0],args[1])
    elif operator == "GT":
        return compute_GT(args[0],args[1])
    elif operator == "ISZERO":
        return compute_ISZERO(args[0])
    elif operator == "SLT":
        return compute_SLT(args[0],args[1])
    elif operator == "SLT":
        return compute_SLT(args[0],args[1])
    elif operator == "MOD":
        return compute_MOD(args[0],args[1])
    elif operator == "XOR":
        return compute_XOR(args[0],args[1])
    elif operator == "BYTE":
        return compute_BYTE(args[0],args[1])
    elif operator == "SDIV":
        return compute_SDIV(args[0],args[1])
    elif operator == "SGT":
        return compute_SGT(args[0],args[1])
    elif operator == "SIGNEXTEND":
        return compute_SIGNEXTEND(args[0],args[1])
    elif operator == "MULMOD":
        return compute_MULMOD(args[0],args[1],args[2])

def compute_MULMOD(a1,a2,a3):
    a1_c =  int(a1,16)
    a2_c =  int(a2,16)
    a3_c =  int(a3,16)
    if a3_c == 0:
        res_c = 0
    else:
        res_c = (a1_c * a2_c) % a3_c
    return hex(res_c)
def compute_SGT(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    if a1_c > a2_c:
        res_c = 1
    else:
        res_c = 0
    return hex(res_c)
def compute_SIGNEXTEND(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    if a1_c >= 32 or a1_c < 0:
        res_c = a2_c
    else:
        signbit_index_from_right = 8 * a1_c + 7
        if a2_c & (1 << signbit_index_from_right):
            res_c = a2_c | (2 ** 256 - (1 << signbit_index_from_right))
        else:
            res_c = a2_c & ((1 << signbit_index_from_right) - 1 )
    return hex(res_c)
def compute_SDIV(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    if a2_c == 0:
        res_c = 0
    elif a1_c == -2**255 and a2_c == -1:
        res_c = -2**255
    else:
        sign = -1 if (a1_c / a2_c) < 0 else 1
        res_c = int(sign * ( abs(a1_c) / abs(a2_c) ))
    return hex(res_c)

def compute_BYTE(a1,a2):
    a1_c =  int(a1,16)
    if a1_c >= 32 or a1_c < 0:
        return hex(0)
    a2_c = int(a2,16)
    res_c = a2_c & (255 << (8 * a1_c))
    res_c = res_c >> (8 * a1_c)
    return hex(res_c)

def compute_XOR(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    res_c = a1_c ^ a2_c 
    return hex(res_c)


def compute_MOD(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    if a2_c == 0:
        return hex(0)
    res_c = a1_c % a2_c & UNSIGNED_BOUND_NUMBER
    return hex(res_c)


def compute_ADD(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    res_c = (a1_c + a2_c) % UNSIGNED_MOD_NUMBER
    return hex(res_c)

def compute_SUB(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    res_c = (a1_c - a2_c) % UNSIGNED_MOD_NUMBER
    return hex(res_c)

def compute_MUL(mulee,muler):
    mulee_c =  int(mulee,16)
    muler_c = int(muler,16)
    res_c = mulee_c * muler_c & UNSIGNED_BOUND_NUMBER
    return hex(res_c)

def compute_DIV(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    if a2_c == 0:
        return hex(0)
    res_c = a1_c // a2_c
    return hex(res_c)

def compute_EXP(base,up):
    base_c =  int(base,16)
    up_c = int(up,16)
    res_c = pow(base_c, up_c, 2**256)
    return hex(res_c)

def compute_AND(a1,a2):
    a1_c =  int(a1,16)
    a2_c = int(a2,16)
    res_c = a1_c & a2_c
    return hex(res_c)

def compute_OR(o1,o2):
    o1_c = int(o1,16)
    o2_c = int(o2,16)
    res_c = o1_c | o2_c
    return hex(res_c)

def compute_NOT(value):
    value_c = int(value,16)
    res_c = (~value_c) & UNSIGNED_BOUND_NUMBER
    return hex(res_c)

def compute_EQ(e1,e2):
    e1_c = int(e1,16)
    e2_c = int(e2,16)
    res_c = e1_c == e2_c 
    return hex(res_c)

def compute_SHR(shift,value):
    s_c = int(shift,16)
    v_c = int(value,16)
    res_c = v_c >> s_c
    return hex(res_c)

def compute_SHL(shift,value):
    s_c = int(shift,16)
    v_c = int(value,16)
    res_c = v_c << s_c
    return hex(res_c)

def compute_XOR(x1,x2):
    x1_c = int(x1,16)
    x2_c = int(x2,16)
    res_c = x1_c ^ x2_c
    return hex(res_c)

def compute_LT(left,right):
    l_c = int(left,16)
    r_c = int(right,16)
    res_c = l_c < r_c
    return hex(res_c)

def compute_SLT(left,right):
    l_c = int(left,16)
    r_c = int(right,16)
    res_c = l_c < r_c
    return hex(res_c)

def compute_GT(left,right):
    l_c = int(left,16)
    r_c = int(right,16)
    res_c = l_c > r_c
    return hex(res_c)

def compute_ISZERO(v):
    v_c = int(v,16)
    res_c = v_c == 0
    return hex(res_c)