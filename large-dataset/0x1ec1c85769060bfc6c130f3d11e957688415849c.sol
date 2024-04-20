pragma solidity ^0.5.0;



contract daoCovenantAgreement {



/* This DAO Covenant Agreement ("DCA") is entered into by and among 

the owners of the Ethereum blockchain network ("Ethereum") addresses that 

provide their authorized digital signatures by 

calling the *signDCA* Solidity function embedded below (\u201cDAO Participants\u201d).



WHEREAS,



The DAO Participants have agreed to enter into this DCA for the purpose of 

regulating the exercise of their rights in relation to digital organizations 

operating on Ethereum ("DAOs");



NOW, THEREFORE in consideration of the premises and the mutual covenants herein contained, 

for good and valuable consideration, the receipt and sufficiency of which are hereby acknowledged, 

the DAO Participants agree as follows: 



1. The DAO Participants shall actively participate in the governance of the DAOs 

in which they have a voting or similar stake on Ethereum ("Affiliated DAOs").



2. The DAO Participants shall support the stated purposes of Affiliated DAOs,

and refrain from any action that may conflict with or harm such purposes.



3. The DAO Participants shall comply in all respects with all relevant laws 

to which they may be subject, if failure to do so would materially impair their  

performance under obligations to Affiliated DAOs.



4. The DAO Participants shall not sell or transfer or otherwise 

dispose of in any manner (or purport to do so) all or any part of, 

or any interest in, Affiliated DAOs, 

unless otherwise authorized and in compliance with applicable law.



5. The results of proper operation of Affiliated DAOs shall be determinative in 

the rights and obligations of, and shall be final, binding upon and non-appealable by, 

the DAO Participants with regard to such DAOs and their assets.

 

6. All claims and disputes arising under or relating to Affiliated DAOs 

shall be settled by binding arbitration.



7. This DCA constitutes legally valid obligations binding and enforceable 

among the DAO Participants in accordance with its terms, 

and shall be governed by the choice of New York law.



8. Digital Signatories to this DCA may opt out of the adoption pool 

established hereby upon calling the *revokeDCA* Solidity function embedded below */



mapping (address => Signatory) public signatories; 

uint256 public DCAsignatories; 



event DCAsigned(address indexed signatoryAddress, uint256 signatureDate);

event DCArevoked(address indexed signatoryAddress);



struct Signatory { // callable information about each DCA Digital Signatory

        address signatoryAddress; // Ethereum address for each signatory in adoption pool

        uint256 signatureDate; // blocktime of successful signature function call

        bool signatureRevoked; // status of adoption 

    }



function signDCA() public {

    address signatoryAddress = msg.sender;

    uint256 signatureDate = block.timestamp; // "now"

    bool signatureRevoked = false; 

    DCAsignatories = DCAsignatories + 1; 

    

    signatories[signatoryAddress] = Signatory(

            signatoryAddress,

            signatureDate,

            signatureRevoked);

            

            emit DCAsigned(signatoryAddress, signatureDate);

    }

    

function revokeDCA() public {

    Signatory storage signatory = signatories[msg.sender];

    assert(address(msg.sender) == signatory.signatoryAddress);

    signatory.signatureRevoked = true;

    DCAsignatories = DCAsignatories - 1; 

    

    emit DCArevoked(msg.sender);

    }

    

function tipOpenESQ() public payable { // **tip Open, ESQ LLC/DAO ether (\u039e) for limited liability DAO research**

    0xBBE222Ef97076b786f661246232E41BE0DFf6cc4.transfer(msg.value);

    }



}
