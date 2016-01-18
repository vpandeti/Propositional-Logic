import sys
import copy
import itertools
from cellModule import Cell
from itertools import combinations
from timeit import itertools
from httplib import FOUND

rows = 0
columns = 0
numberOfVariables = 0
numberOfVariablesInGrid = 0
listOfVariables = []
extraVariablesLists = []
finalLists = []
mainfinalLists = []
count = 0

def parse_file(filepath):
    # read the layout file to the board array
    global rows,columns
    board = []
    fin = open(filepath)
    line1 = fin.readline()
    boardconfig = line1.split(" ")
    rows = boardconfig[0]
    columns = boardconfig[1]
    boardConfigList = []
    boardConfigList.append("p")
    boardConfigList.append("cnf")
    boardConfigList.append(rows)
    boardConfigList.append(columns)
    boardConfigList[-1] = boardConfigList[-1].strip()
    #board.append(boardConfigList)
    row = 0
    Xcount = 1
    for line in fin:
        cell = []
        column = 0
        for value in line.split("\n")[0].split(","):
            if(value =='X'):
                value = 'X'+`Xcount`
                print ("value is $$$$$$$$$$$$$$$$$$$$$$:  ",value)
                Xcount += 1
            c = Cell(value, row, column)
            cell.append(c)
            column +=1
        board.append(cell)
        row +=1   
    
                    
    fin.close()
    return board


def convert2CNF_backup(board, output):
    # interpret the number constraints

    fout = open(output, 'w')
    boardRows = len(board)
    #print boardRows
    listAlpha = ['A','B','C','D']
    #values = itertools.combinations(listAlpha,(listAlpha.__len__()))
    #print list(values)
    #print ("rows is: ",rows," columns is: ",columns)
    for eachrow in range(boardRows):
        for column in range(len(board[eachrow])):
            fout.write(board[eachrow][column].value)
            fout.write(" ")
        fout.write("\n")
    fout.close()
    
def convert2CNF(board, output):
    # interpret the number constraints
    #fout = open(output, 'w')
    boardRows = len(board)
    global numberOfVariables
    global numberOfVariablesInGrid
    global listOfVariables
    global extraVariablesLists
    #print boardRows
    """listAlpha = ["A",'B','C','D']
    values = itertools.combinations(listAlpha,1)
    print list(values)"""
    #print ("rows is: ",rows," columns is: ",columns)
    for eachrow in range(boardRows):
        for column in range(len(board[eachrow])):
            if(board[eachrow][column].value[0] == 'X'):
                #print "found"
                numberOfVariables += 1
    #print numberOfVariables
    
    string = 'X'
    for i in range(1,numberOfVariables+1):
        string += `i`
        listOfVariables.append(string)
        string = 'X'
    
    clauseGenerator(copy.deepcopy(board),listOfVariables)
    
    #starting with extra variables
    #starting with extra variables
       
    totalClauses = len(mainfinalLists)
    """for eachlist in mainfinalLists:
        totalClauses += len(eachlist)-1"""
    
    print numberOfVariables
    fout = open(output, 'w')
    fout.write("p")
    fout.write(" ")
    fout.write("cnf")
    fout.write(" ")
    fout.write(str(numberOfVariables))
    fout.write(" ")
    fout.write(str(totalClauses))
    fout.write("\n")
    
    if(len(extraVariablesLists) >0):
        for everyValue in extraVariablesLists:
            fout.write(everyValue.split("Z")[1])
            fout.write(" ")
        fout.write("\n")
    
    for eachElement in mainfinalLists:
        for value in eachElement:
            fout.write(value)
            fout.write(" ")
        fout.write("\n")
    
    fout.close()
       
    
    
def clauseGenerator(board,listOfVariables):
    #global listOfVariables
    global finalLists
    global extraVariablesLists
    global numberOfVariables
    global count
    
    
    #print ("listOfVariables is: ",listOfVariables)
    neighbours = []
    values = []
    count = numberOfVariables+1
    for row in range(len(board)):
        for column in range(len(board[row])-1):
            #print("row is: ",row," column is: ",column," count is: ",count," and value is: ",board[row][column].value)
            if(board[row][column].value[0] != 'X'):
                dictionaryList = calculateNumberOfNeighborX(board,row,column,len(board),len(board[row]))
                valueOfX = dictionaryList['key'][0]
                neighboursListOfCell = dictionaryList['key'][1]
                print ("************************** value of neightbor X is: ",dictionaryList['key'][0]," list is: ",dictionaryList['key'][1])
                #print ("not skipping .....................")
                #print ("value of cell is:: ",board[row][column].value)
                if(int(board[row][column].value) > valueOfX):
                    raise Exception('wrong value in the grid !!!')
                elif(int(board[row][column].value) == valueOfX):
                    neighbours = neighboursListOfCell
                    tempListIntoMainLists = []
                    for values in neighbours:
                        tempListIntoMainLists = [values.split("X")[1],'0']
                        mainfinalLists.append(tempListIntoMainLists)
                elif(int(board[row][column].value) < valueOfX):
                        
                    neighbours = neighboursListOfCell
                    print neighbours
                    newListTemp = []
                    for value in neighbours:
                        game = copy.deepcopy(list(neighbours))
                        game.remove(value)
                        game = [eachElement.replace(eachElement, "-"+eachElement) for eachElement in game]
                        game.insert(0, value)
                        newListTemp.append(game)
                        print ("newlisttemp  is: ",newListTemp)

                    stringList = ['-Z','Z']
                    for i in range(len(newListTemp)):
                        stringList[0] += `count`
                        stringList[1] += `count`
                        if stringList[1] not in extraVariablesLists:
                            extraVariablesLists.append(stringList[1])
                        print newListTemp[i]
                        print stringList[0]
                        tempListIntoMainLists = []
                        print stringList[0].split("-Z")[1]
                        
                        for j in newListTemp[i]:
                            tempListIntoMainLists = []
                            tempListIntoMainLists.append("-"+(stringList[0].split("-Z")[1]))
                            if(j[0]=='-'):
                                tempListIntoMainLists.append("-"+j.split("-X")[1])
                            else:
                                tempListIntoMainLists.append(j.split("X")[1])
                            tempListIntoMainLists.append('0')
                            mainfinalLists.append(tempListIntoMainLists)
                            
                        count +=1
                        #print ("newListTemp[i] after appending -Z is: ",newListTemp[i])
                        #print ("extraVariablesLists after appending +Z is: ",extraVariablesLists)
                        #print ("finalLists is: ",finalLists)
                        stringList[0] = '-Z'
                        stringList[1] = 'Z'
                        
                print neighbours
                print mainfinalLists
                
            else:
                print("skipping -----------------")  
                

def calculateNumberOfNeighborX(board,row,column,totalRows,totalColumns):
    total = 0
    neighboursList = []
    dictionaryList = {}
    print ("totalRows is: ",totalRows," totalColumns is: ",totalColumns)
    print ("row is: ",row," and column is: ",column)
    if(column <= totalColumns-2):
        if((board[row][column+1].value[0] == 'X')):
            neighboursList.append(board[row][column+1].value)
            total += 1
    if(row <= (totalRows-2)):
        if((board[row+1][column].value[0] == 'X')):
            neighboursList.append(board[row+1][column].value)
            total += 1
    if(row-1 >= 0):
        if ((board[row-1][column].value[0] == 'X')):
            neighboursList.append(board[row-1][column].value)
            total += 1
    if(column-1 >= 0):
        if (board[row][column-1].value[0] == 'X'):
            neighboursList.append(board[row][column-1].value)
            total += 1
    if((row-1 >= 0) and (column-1 >= 0)):
        if (board[row-1][column-1].value[0] == 'X'):
            neighboursList.append(board[row-1][column-1].value)
            total += 1
    if((row-1 >= 0) and ((column <= totalColumns-2))):
        if (board[row-1][column+1].value[0] == 'X'):
            neighboursList.append(board[row-1][column+1].value)
            total += 1
    if((column-1 >= 0) and ((row <= totalRows-2))):
        if (board[row+1][column-1].value[0] == 'X'):
            neighboursList.append(board[row+1][column-1].value)
            total += 1
    if((column <= totalColumns-2) and (row <= totalRows-2) and ((column+1)<=len(board[row+1])-1)):
        print (column+1)
        if (board[row+1][column+1].value[0] == 'X'):
            neighboursList.append(board[row+1][column+1].value)
            total += 1
    dictionaryList['key']=[total,neighboursList]
    return dictionaryList

if __name__ == '__main__':
    
    if len(sys.argv) < 3:
        print 'Layout or output file not specified.'
        exit(-1)
    print sys.argv[1]
    board = parse_file(sys.argv[1])
    convert2CNF(board, sys.argv[2])
    
    

