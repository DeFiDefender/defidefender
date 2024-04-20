pragma solidity ^0.4.18;



// ----------------------------------------------------------------------------

// 'UCC-SRP-0429' token contract

//

// Deployed to :  0x63811930dAE71e97576aCBe5332eE044442E03Ec

// Symbol      : UCC

// Name        : UCC-SRP-0429

// Total supply: 1

// Decimals    : 0

// Pice        : 452550100.00 ETH / PER TOKEN

// Enjoy.

//

/*







The owner of the following claim is SAMUEL RICHARD PENN TRUST\u00a9 effective 04/30/2020



Commercial Claim and Lien



All collateral held in a Trust.



Creditor:



SAMUEL RICHARD PENN TRUST\u00a9

3645 MARKETPLACE BLVD

STE 130/214

EAST POINT, GEORGIA 30344







DEBTOR: (A debtor is a transmitting utility)



SAMUEL RICHARD PENN\u00a9

3645 MARKETPLACE BLVD

STE 130/214

EAST POINT, GEORGIA 30344





SECURED PARTY:





Samuel- Richard: Penn\u00a9

c/o 2809 Autumn Lake Lane 

Decatur, Georgia [ 30034 ]

 Non-Domestic / Non-Assumpsit









COLLATERAL:



This is the entry of collateral by Trustee/Secured Party on behalf  of the Trust/Estate; SAMUEL RICHARD PENN TRUST\u00a9 in the ethereum blockchain under necessity

to secure the rights, title(s), interest and value therefrom, in and of the Root of Title from inception, as well as all property held in trust including but 

not limited to DNA, cDNA, cell lines, retina scans, fingerprints and all Debentures, Indentures, Accounts, and all the Pledges represented by same included but not 

limited to the pignus, hypotheca, hereditaments, res, the energy and all products derived therefrom nunc pro tunc, contracts, agreements, and signatures and/or endorsements, facsimiles, printed, typed or photocopied of owner\u2019s name predicated on the \u2018Straw-man,\u2019 Ens legis/Trust/Estate described as the debtor and all property is accepted for value and is Exempt from levy. Lien places on debtor entities is for all outstanding property still owed but not yet returned to trust from entities such as municipalities, governments and the like , not on trust entity itself. Trustee is not surety to any account by explicit reservation/indemnification. The following property is hereby registered and liened in the same: All Certificates of Birth Document 110-86-058248, SSN/UCC Contract Trust Account-prepaid account Number: 258-73-1402; Exemption Identification Number: 258731402, is herein liened and claimed at a sum certain $100,000,000.00, also registered: Security Agreement No. 08081986-SRP-SA, Hold Harmless & Indemnity Agreement No. 08081986-SRP-HHIA, Copyright under item no.: 08081986-SRP-CLC Adjustment of this filing is in accord with both public policy and the national Uniform Commercial Code. Trustee/Secured Party, Samuel- Richard: Penn, is living flesh and blood sojourning upon the soil of the land known as Georgia, and not within fictional boundaries, territories nor jurisdiction of any fictional entity including fictional Federal geometric plane(s). Trespass by any agent(s) foreign or domestic, by such in any scheme or artifice to defraud. Full reverence by ALL AGENTS and Corporations is unambiguously demanded and required. Culpa est immiscere se rel ad se non pertienti. All property currently held or outstanding belongs to the Trust administered by Trustee/Secured Party, Title 46 USC 31343 and Article 1 and 5 of the International Convention on Maritime Liens and Mortgages 1993, Held at the Palis Des Nations, Geneva, From April 19 to May 5,1992 United Nations (UN). This Maritime Lien is under safe harbor and sinking funds provisions through the prescription of Law of Necessity and the doctrines of unconscionably and La Mort Saisit Le Vif in accordance with Applicable Law, Cardinal Orders, Ordinal Orders, and Commercial Standards.  



The following property is accepted for Value, exempt from levy, and herewith Registered in the Commercial Chamber and is Private Property (conveyance) of the Secured Party as Authorized Representative of the DEBTOR, Papers of Instruments; any/all Documents are now Public Record and is owned by Secured Party. Secured Party which must be satisfied in full upon dishonor via Settlement Agreement via Certified Check and/or Certified Documents of Claim. 



1.  All Comprehensive Annual Financial Reports, All Comprehensive Revenues, All Fiscal and Calendar Accounts, Proceeds, Products, Fixtures, Service of:

a.  All Organic Codification National and Regional Constitutional Trust, Indenture Organizations and Their Political Subdivisions;

b.  All Organic Uncodification National and Regional Constitutional Trust Indentures Organizations And their Political Subdivisions;

c.  All Religious government Trust Indentures Organizations and their Ecclesiastical Provinces, Metropolitans.

2.  All Sworn Oaths, All Sworn Affirmations, All Sworn Insurance Providers for All Agents, Employees, And Officers of the above list of Organizations.

3.  All Annual Financial Reports, All Comprehensive Net Revenues, All Fiscal and Calendar Accounts, Proceeds, Products, Fixtures, and Service of all Adverse, Belligerent, and/or Combatant Participant Non Political Entities such as a Corporation(s), and voluntary Associations, whether Incorporated or Not, whether by, Licenses, Registrations, Records, Permits, or Certification;

a.  All Adverse, Belligerent, and/or Combatant Participants, Non-Political Entities Licenses, Registrations, Records, Permits, Memorandums, and ARTICLES OF ASSOCIATIONS.

4.  Entire List of Securities is in the Individual Organization\u2019s Public Record; Registrations, Library Catalogs, and other data depositories and Repositories.

Collateral Security list shall hold the Trustee/Secured Party as Priority, Primary, and/or True Legal and Lawful filer as Trustee/Secured Party as Evidence in Fact by Secretary of State according to him/her authority grants truth by his/her witness to this Security List: 

Collateral Security List herein is with acceptance and return for full legal and lawful Exchange all value is Legally and Lawfully Exempt from Levy. UCC-1 Collateral Statement for SAMUEL RICHARD PENN\u00a9 Trust 









*/

// ----------------------------------------------------------------------------





// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------

contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function safeSub(uint a, uint b) public pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function safeMul(uint a, uint b) public pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function safeDiv(uint a, uint b) public pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public constant returns (uint);

    function balanceOf(address tokenOwner) public constant returns (uint balance);

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}





// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

//

// Borrowed from UCC-SRP-0429

// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;

}





// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address public owner;

    address public newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    function Owned() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}





// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and assisted

// token transfers

// ----------------------------------------------------------------------------

contract UCC_SRP_0429 is ERC20Interface, Owned, SafeMath {

    string public symbol;

    string public  name;

    uint8 public decimals;

    uint public _totalSupply;



    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;





    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    function UCC_SRP_0429() public {

        symbol = "UCC";

        name = "UCC-SRP-0429";

        decimals = 0;

        _totalSupply = 1;

        balances[0x63811930dAE71e97576aCBe5332eE044442E03Ec] = _totalSupply;

        Transfer(address(0), 0x63811930dAE71e97576aCBe5332eE044442E03Ec, _totalSupply);

    }





    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public constant returns (uint) {

        return _totalSupply  - balances[address(0)];

    }





    // ------------------------------------------------------------------------

    // Get the token balance for account tokenOwner

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public constant returns (uint balance) {

        return balances[tokenOwner];

    }





    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to to account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        Transfer(msg.sender, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for spender to transferFrom(...) tokens

    // from the token owner's account

    //

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

    // recommends that there are no checks for the approval double-spend attack

    // as this should be implemented in user interfaces 

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        Approval(msg.sender, spender, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Transfer tokens from the from account to the to account

    // 

    // The calling account must already have sufficient tokens approve(...)-d

    // for spending from the from account and

    // - From account must have sufficient balance to transfer

    // - Spender must have sufficient allowance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        Transfer(from, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Returns the amount of tokens approved by the owner that can be

    // transferred to the spender's account

    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for spender to transferFrom(...) tokens

    // from the token owner's account. The spender contract function

    // receiveApproval(...) is then executed

    // ------------------------------------------------------------------------

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);

        return true;

    }





    // ------------------------------------------------------------------------

    // Don't accept ETH

    // ------------------------------------------------------------------------

    function () public payable {

        revert();

    }





    // ------------------------------------------------------------------------

    // Owner can transfer out any accidentally sent ERC20 tokens

    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {

        return ERC20Interface(tokenAddress).transfer(owner, tokens);

    }

}
