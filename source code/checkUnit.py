class CheckUnit:
    def __init__(self, type,ins):
        self.type = type
        self.ins = ins
    def get_unit_type(self):
        return self.type
    def get_unit_ins(self):
        return self.ins
    def set_caller_address(self,address):
        self.caller = address
    def get_caller_address(self):
        return self.caller
    def set_call_return(self,call_return):
        self.call_return = call_return
    def get_call_return(self):
        return self.call_return
    def get_sstore_value(self):
        return self.store_value
    def get_sstore_key(self):
        return self.store_key
    def get_sload_key(self):
        return self.sload_key 
    def set_sload(self,key,value):
        self.sload_key = key
        self.sload_value = value
    def set_iszero(self,iszero):
        self.iszero = iszero
    def get_iszero(self):
        return self.iszero
    def set_sstore(self,key,value):
        self.store_key = key
        self.store_value = value
    def set_eq(self,eq_left,eq_right):
        self.eq_left = eq_left
        self.eq_right = eq_right
    def get_eq_left(self):
        return self.eq_left
    def get_eq_right(self):
        return self.eq_right
    def print_data(self):
        print(self.type,self.ins)
        if self.type == "CALLER":
            print(self.caller)
        elif self.type == "SLOAD":
            print(self.sload_key,self.sload_value)
        elif self.type == "SSTORE":
            print(self.store_key,self.store_value)
        else:
            print("no extra param!")