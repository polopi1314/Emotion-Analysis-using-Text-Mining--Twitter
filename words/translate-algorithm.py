# Author : Marco Cardoso
# Date : 8/4/2017 at 2:43 AM



''' Description of the script :

    The main objective is to simple translate two txt files containing some thousands of english words.
    This script could be used to translate multiple words from a single file, since the words are disposed line by line.


'''

'''
    Descricao deste script :

    O principal objetivo e simplesmente traduzir dois arquivos txt que possuem alguumas milhares de palavras.
    Este script pode ser utilizado para traduzir multiplas palavras de um arquivo simples,desde que as palavras estejam dispostas linha apos linha.
'''


from json import JSONDecodeError

from googletrans import Translator
import time
import traceback

def main():


    start_time = time.time()

    print("============ STARTING THE TRANSLATING OF THE POSITIVE WORDS FILE ==========")

    print("================ OPENING THE FILE ===========")
    try:
        englishPositiveWords = open("positive-english-words.txt", 'r')
    except:
        raise AttributeError("=====SOMETHING HAPPENED WITH THE FILE ======")

    print("=========== CREATING THE BLANK FILE =========")

    try:
        file = open("positive-portuguese-words.txt", 'w')
    except:
        raise AttributeError("=====SOMETHING HAPPENED WITH THE FILE ======")
    print("=========FILE WAS SUCCESSFULLY CREATED ======")

    print("============== TRANSLATING...==============")

    if file != None:
        translateWords(file,englishPositiveWords)
    else:
        raise AttributeError("=====SOMETHING HAPPENED WITH THE FILE ======")

    file.close()
    print("========YEAH ! POSITIVE WORDS WERE TRANSLATED ========")
    print("============ STARTING THE TRANSLATING OF THE POSITIVE WORDS FILE ==========")

    print("================ OPENING THE FILE ===========")
    try:
        englishNegativeWords = open("negative-english-words.txt", 'r')
    except:
        raise AttributeError("=====SOMETHING HAPPENED WITH THE FILE ======")

    print("=========== CREATING THE BLANK FILE =========")

    file = None
    try:
        file = open("negative-portuguese-words.txt", 'w')
    except:
        print("========= SOMETHING HAPPENED ========")
        print("========= FINISHING THE SCRIPT ======")
    print("=========FILE WAS SUCCESSFULLY CREATED ======")

    print("============== TRANSLATING...==============")

    if file != None:
        translateWords(file,englishNegativeWords)
    else:
        raise AttributeError("=====SOMETHING HAPPENED WITH THE FILE ======")

    file.close()
    print("========YEAH ! POSITIVE WORDS WERE TRANSLATED ========")

    finish_time = time.time() - start_time
    print("Elapsed time : " + finish_time.__str__())



lastWord = ""
restart = False
def translateWords(file,words):
    global restart
    global lastWord
    try:
        translator = Translator(service_urls=[
            'translate.google.com'
        ])

        for word in words:
            if restart == True:
                word = lastWord
                restart = False

            lastWord = word
            translatedWord = translator.translate(word, dest='pt', src='en')
            translatedWord = str.lower(translatedWord.text)
            print("English : " + word  + " Portuguese : " + translatedWord)
            try:
                file.write(translatedWord + "\n")
            except:
                pass

    except JSONDecodeError as err:
        traceback.print_tb(err.__traceback__)
        print("HOLDING ON FOR FIVE SECONDS TILL THE GOOGLE ACCEPT OUR CONNECTION ...")
        time.sleep(5)
        print("GETTING BACK TO THE SCENE ...")
        translateWords(file,words)
    except ConnectionError as err:
        traceback.print_tb(err.__traceback__)
        restart = True
        print("HOLDING ON FOR FIVE SECONDS TILL THE GOOGLE ACCEPT OUR CONNECTION ...")
        time.sleep(5)
        print("GETTING BACK TO THE SCENE ...")
        translateWords(file, words)
    except Exception as err:
        traceback.print_tb(err.__traceback__)
        print("FAILED ....")
        translateWords(file, words)
        pass



main()
