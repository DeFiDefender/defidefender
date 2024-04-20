class BasicBlock:
    def __init__(self, start_address):
        self.start = start_address
        self.instructions = []  # each instruction is a string
        self.checkUnits = []
        self.jump_to = set()
    def get_start_address(self):
        return self.start
    def set_end_address(self,end_address):
        self.end = end_address
    def get_end_address(self):
        return  self.end
    def set_fall_to(self,fall_to):
        self.fall_to = fall_to
    def get_fall_to(self):
        return  self.fall_to
    def add_instruction(self, instruction):
        self.instructions.append(instruction)
    def add_jump_to(self,jump_to):   
        self.jump_to.add(jump_to)
    def get_jump_to(self):
        return self.jump_to
    def get_instructions(self):
        return self.instructions
    def add_checkUnit(self,checkUnit):
        self.checkUnits.append(checkUnit)    
    def get_checkUnits(self):
        return self.checkUnits
    def set_block_type(self, type):
        self.type = type
    def get_block_type(self):
        return self.type
    def display(self):
        print("================")

