# DefiDefender



## Description


In this paper, we introduce DeFi Contract Traps (DCTs), which are malicious code snippets embedded within DeFi smart contracts by misbehaving developers. We identify five types of DCTs and describe their behaviors, highlighting how attackers exploit them for unfair profits. To combat these traps, we propose DeFiDefender, a symbolic execution tool capable of detecting DCTs. We evaluate DeFiDefender using a manually labeled dataset of 700 smart contracts, demonstrating its high effectiveness and efficiency. DeFiDefender achieves an average accuracy of 98.17%, precision of 99.74%, and recall of 89.24%, with a runtime of only 0.48s per contract. Additionally, we apply DeFiDefender to a large-scale dataset of 20,679 real DeFi-related Ethereum smart contracts and find that 52.13% of them contain at least one DCT. Our findings underscore the prevalence of centralized issues in DeFi contracts within a zero-trust environment, highlighting the importance of tools like DeFiDefender for ensuring the integrity and security of DeFi applications.


## Getting Started

### Dependencies

* python3
* solc
* Geth
* ...


### Installing

* Install each version of the solidity compiler.

        sudo add-apt-repository ppa:ethereum/ethereum
        sudo apt-get update
        sudo apt-get install solc
* Install Geth.

        sudo apt-get update
        sudo apt-get install ethereum

### Executing program
    
* Change the `solFilePath` variable in `main.py` to the actual folder of dataset.
* Run main python file.

        python3 main.py

## Folder Structure

### Experiment

* large-dataset 

    For the large-scale dataset to evaluate the prevalence of the defined DCTs in the Ethereum.This dataset comprises 20,679 Ethereum smart contracts related to DeFi, with an average length of 667.5 lines of code, extracted from a pool of 117,926 verified contracts. Initially, we tokenized the Ethereum smart  contracts into word lists by eliminating punctuation and spaces, which typically do not convey meaningful information. Subsequently, we segmented the words based on Camel Casing rules. For instance, the term "moneyLending" was segmented into "money" and "Lending". Following segmentation, we stemmed the words using Porter’s stemmer, wherein, for example, "lending" was transformed into "lend". Finally, we identified DeFi-related contracts by detecting the presence of finance-related keywords within the smart contracts. These finance-related keywords were sourced from two main categories: firstly, we leveraged the Merriam-Webster thesaurus, which encompasses 12 finance synonyms and 75 finance-related words. Additionally, we incorporated seven other keywords, namely interest, lend, p2p, loan, credit, reward, and bonus.

* small-dataset

    For the samll dataset,this dataset comprises 700 smart contracts, with an average length of 514.19 lines of code.  To create the dataset, we randomly selected 700 smart contracts from a pool of 117,926 verified Ethereum smart contracts. Subsequently, we manually examined each contract to determine whether it pertained to decentralized finance (DeFi). Contracts unrelated to DeFi were excluded from the dataset. This process was repeated until a total of 700 DeFi-related contracts were identified.

* label.txt

    The ground truth of the small-dataset. The labeling was conducted through a manual process by two developers. To address potential biases, the labeling process involved several steps to ensure accuracy and minimize errors. Initially, a random selection of 700 Ethereum smart contracts was made from a larger pool. Each contract was then reviewed to determine its relevance to decentralized finance (DeFi), with non-DeFi related contracts being excluded.After this initial filtering, another round of random selection focused solely on identifying DeFi-related contracts until 700 were obtained. Each selected contract underwent a thorough examination to determine if it exhibited any of the five defined decentralized finance characteristics (DCTs).The manual scrutiny was carried out independently by the two developers to minimize errors. Any disparities in their findings were discussed until a consensus was reached, ensuring the correctness of the labeled dataset. This meticulous process took approximately 1.5 months.Furthermore, after the manual curation process, the accuracy of the dataset was rigorously evaluated by the same two developers. They independently assessed each smart contract for its relevance to DeFi and the presence of the defined DeFi characteristics. Any discrepancies were thoroughly discussed until a consensus was reached. This validation process aimed to ensure the correctness and reliability of the labeled dataset.

### Source code
* `baseBlock.py` describes the basic structure class of a block.
* `calculate.py` describes the processing related to instruction calculation.
* `checkUnit.py` records critical information in pattern detection.
* `contract_text_process.py` do the process of filtering DeFi-related contracts from the large dataset.
* `contract.py` process the symbolic execution main process of smart contract.
* `label.py` describes the basic structure class of a manual label.
* `main.py` the enterpoint of process.

