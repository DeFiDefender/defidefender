import re
from nltk.stem import PorterStemmer
import requests
import pandas as pd
import shutil
import os

collectFilePath = "./process-dataset/"
originFilePath = "./git-dataset/"
cleanFilePath = "./clean-dataset/"

syns = ['bankroll', 'capitalize', 'endow', 'fund', 'stake', 'subsidize', 'underwrite']
related_words = ['grubstake','cofinance','refinance','advocate','aid','stand','establish',
'back','champion','endorse','patronize','sponsor','pay','organize','award','draw','deposit',
'support','maintain','nourish','discharge','receive']
Defi_words = ['interest', 'lend', 'p2p', 'loan', 'credit', 'reward', 'bonus','ERC','token','mint']

world_word = []


def split_contract_into_words(contract_text):


    contract_text =  re.sub(r'[^\w\s]', ' ', contract_text)
    

    words = contract_text.split()
    

    words = [word for word in words if word]


    words = [word for word in words if word != "_"]


    for index,word in enumerate(words):
        process_words = split_camel_case(word)
        words = words + process_words
        words.remove(word)


    words = [word for word in words if not word.isdigit()]



    words = list(set(words))

    return words

def split_camel_case(word):

    words = re.findall(r'[A-Z]?[a-z\d]+|[A-Z\d]+(?=[A-Z]|$)', word)

    return words

def remove_comments(contract_text):
    
  
    contract_text = re.sub(r'//.*', '', contract_text)
    
    
    contract_text = re.sub(r'/\*.*?\*/', '', contract_text, flags=re.DOTALL)
    
    return contract_text

def stem_word(word):
    stemmer = PorterStemmer()
    stemmed_word = stemmer.stem(word)
    return stemmed_word

def is_Defi(words):
    for word in words:
        for pattern in syns:
            if word_match(word,pattern):
                msg = "match: " + pattern
                write_msg(msg)
                return True
        for pattern in related_words:
            if word_match(word,pattern):
                msg = "match: " + pattern
                write_msg(msg)
                return True
        for pattern in Defi_words:
            if word_match(word,pattern):
                msg = "match: " + pattern
                write_msg(msg)
                return True
    return False

def contract_process():
    global world_word
    for root, _, files in os.walk(collectFilePath):
        for f in files:
            file_path = os.path.join(root, f)
            with open(file_path,"r",encoding='utf-8') as file:
                print("process file: " + f)
                contract_text = file.read()
                contract_text = remove_comments(contract_text)
                words = split_contract_into_words(contract_text)
                if  is_Defi(words):
                    if os.path.isfile(file_path):
                        shutil.copy(file_path, cleanFilePath)
            world_word = world_word + words
            world_word = list(set(world_word))
    write_msg(str(world_word))

def getRelatedWords():

    request_url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/finance?key=63a8e38e-077b-4918-a658-6937cd9abaeb"
    response = requests.get(request_url)
    if response.status_code == 200:

        json_data = response.json()
        print(json_data['meta']['syns'])
    else:
        print("Failed to retrieve data.")


def word_match(word,pattern):
    matches = re.findall(pattern, word, re.IGNORECASE)
    return len(matches) > 0

def filter_contract():

    df = pd.read_excel('output12.xlsx')

    data_dict = df.to_dict(orient='records')

    for i,data in enumerate(data_dict):
        if not isinstance(data['mainContract'],str):
            continue
        if data['StackOverFlow'] == True:
            continue
        file_name = data['address'] + "_" + data['mainContract'] + '.sol'
        search_path = search_files(originFilePath,file_name)
        if search_path == "notfind":
            msg = file_name + " not find file"
            write_msg(msg)
            continue
        if not os.path.isfile(search_path):
            msg = file_name + " no file"
            write_msg(msg)
            continue
        shutil.copy(search_path, collectFilePath)

def search_files(folder, excelFile):
    for root, _, files in os.walk(folder):
        for file in files:
            if file == excelFile:
                return os.path.join(root, file)
    return "notfind"

def write_msg(msg):
    with open("./process.log",'a') as f:
        f.write(msg)
        f.write('\n')
        f.close()

def cleanLog():
    with open("./process.log",'w') as f:
        f.flush()
        f.close()
   
def cleanFolder():
    if os.path.exists(collectFilePath):
        shutil.rmtree(collectFilePath)
    os.mkdir(collectFilePath)

def run():
    cleanLog()
    contract_process()

def filter():
    cleanFolder()
    filter_contract()


run()

