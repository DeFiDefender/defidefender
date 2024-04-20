class Label:
    def __init__(self, fileName):
        self.fileName = fileName
    def setMainContractName(self,mainContractName):
        self.mainContractName = mainContractName
    def setLabelSP(self,LabelSP):
        self.LabelSP = LabelSP
    def setLabelSSP(self,LabelSSP):
        self.LabelSSP = LabelSSP
    def setLabelSTP(self,LabelSTP):
        self.LabelSTP = LabelSTP
    def setLabelTS(self,LabelTS):
        self.LabelTS = LabelTS
    def setLabelFT(self,LabelFT):
        self.LabelFT = LabelFT
    def getLabelSP(self):
        return self.LabelSP 
    def getLabelSTP(self):
        return self.LabelSTP 
    def getLabelTS(self):
        return self.LabelTS 
    def getLabelSSP(self):
        return self.LabelSSP 
    def getLabelFT(self):
        return self.LabelFT 
    def getFileName(self):
        return self.fileName
    def getMainContractName(self):
        return self.mainContractName
    