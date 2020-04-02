defmodule Assign2 do
  @moduledoc """
  Documentation for Assign2.
  """
  import String, only: [to_integer: 1]

  @newline "
"

  def diceIncrease(list, index) do
    if ( index+1 == String.length(list) )do
      0
    else
      index+1
    end
  end
  def createBlocks(dice, board) do

    list = Map.get(dice,:list)
    index = Map.get(dice,:index)
    dice2 = Map.replace(dice, :index, diceIncrease(list,index))
    type = String.at(list, index)
    index2 = Map.get(dice2,:index)
    rot = String.at(list, index2)
    orient = rem(to_integer(rot),5)
    dice3 = Map.replace(dice2, :index, diceIncrease(list,index2))
    middle = Map.get(board, :middle)
    map = Map.put(%{}, :rot, orient)

    boar = Map.get(board, :board)
    x=0
    y=middle

    map3=
      case type do
        "1" ->
          map2= Map.put(map, :type, "y")
          map3 = Map.put(map2, :temp, shiftTop([[x,y], [x,y+1], [x-1,y], [x-1,y+1]],boar))

        "2" ->
          map2 = Map.put(map, :type, "r")
          map3 = Map.put(map2, :temp, initialize(orient, [[x,y], [x,y+1], [x-1,y], [x-1,y-1]],boar ))

        "3" ->
          map2 = Map.put(map, :type, "g")
          map3 = Map.put(map2, :temp, initialize(orient, [[x,y], [x,y-1], [x-1,y], [x-1,y+1]],boar))

        "4" ->
          map2 = Map.put(map, :type, "b")
          map3 = Map.put(map2, :temp, initialize(orient, [[x,y], [x,y+1], [x,y-1], [x-1,y-1]],boar))

        "5" ->
            map2 = Map.put(map, :type, "o")
            map3 = Map.put(map2, :temp, initialize(orient, [[x,y], [x,y+1], [x,y-1], [x-1,y+1]],boar))
        "6" ->
            map2 = Map.put(map, :type, "p")
            map3 = Map.put(map2, :temp, initialize(orient, [[x,y], [x,y+1], [x,y-1], [x-1,y]],boar ))
        "7" ->
            map2 = Map.put(map, :type, "c")
            map3 = Map.put(map2, :temp, initialize(orient, [[x,y], [x,y+1], [x,y-1], [x,y+2]],boar))
      end
      [map3,dice3]
  end
  def initialize(rotation, points,board) do
    [x,y] = Enum.at(points,0)
        newPoints=
        case rotation do
          1 ->
            points
          2 ->
            rotate(points,2,x, y)
          3 ->
            rotate(points,3,x, y)

          4 ->
            rotate(points,4,x, y)
        end
        points = shiftTop(newPoints,board)
        if points == nil do
          false
        else points
        end
  end
  def print({:game,board,dice,piece,state}) do

    newBoard = placeOnBoard(piece,board,state)
    count = Map.get(newBoard,:count)
    plural=
      if(count>1 or count==0) do
          " " <> Integer.to_string(count)<>" pieces"
      else
          " " <> Integer.to_string(count)<>" piece"
      end

    board = Map.get(newBoard, :board)
    line=String.slice(Enum.at(board,0),0,String.length(Enum.at(board,0))-1)

    List.to_string(List.replace_at(board, 0, line<>plural<>"\n"))
  end
  def createBoard(rows, column) do
    string = (1..rows |> Enum.map( fn _ -> "|" <> String.duplicate(" ", column) <> "|\n"end))
    board = List.insert_at(string, length(string), "+" <> String.duplicate("-",column)<> "+\n")
    board
  end
  def readFrom(aString) do
    init() |>
      readFrom(aString)
  end
  def init() do
    {:game,%{},[],nil,true}
  end
  def readFrom(aGame, aString) do
    List.foldl(String.split(aString,@newline),aGame,&(doCommand(String.split(&1," "),&2)))
  end
  def doCommand([""|_], aGame), do: aGame
  def doCommand(["board",c,r],{:game,%{},dice,nil,state}) do
    rows = to_integer(r)
    width = to_integer(c)
    map = Map.put(%{},:row, rows)
    map2 = Map.put(map,:col, width)

    map3 =
    if (rem(width,2) == 1) do
      Map.put(map2, :middle, div(width,2)+1)
    else
      Map.put(map2, :middle, div(width,2))
    end

    map4= Map.put(map3, :count,0)
    map5= Map.put(map4, :powerup,nil)
    board = Map.put(map5, :board, createBoard(rows, width))
    {:game,board,dice,nil,state}
  end
  def doCommand(["dice"|list],{:game,board,d,piece,state}) do
    map = Map.put(%{}, :index,0)
    a=""
    list1 = List.to_string(list)
    dice = Map.put(map, :list, list1)
    {:game,board,dice,piece,state}
  end
  def rotate(points,num,pX, pY) do
    newPoints = Enum.map(points, fn[x,y] -> [(y-pY) + pX , -(x-pX)+pY] end)

    if(num-1 > 1) do
      rotate(newPoints,num-1,pX, pY)
    else
      newPoints
    end
  end
  def shiftTop(points,board)do
    if Enum.all?(points,fn[x,y] -> x>=0 end) == false do
      newPoint = Enum.map(points, fn[x,y] -> [x+1,y] end)
      shiftTop(newPoint,board)
    else
      if(fillTest(points, board) == true)do
        points
      else
        nil
      end
    end
  end
  def placeOnBoard(pieceMap, boardMap,state)do
    if(pieceMap != nil and Map.get(pieceMap, :points) != false and state != false)do

      [h|t] = Map.get(pieceMap, :points)
      [row,width] = h
      type = Map.get(pieceMap,:type)
      board = Map.get(boardMap,:board)
      line = Enum.at(board,row)
      b = List.replace_at(board, row, String.slice(line, 0, width) <> type <> String.slice(line, width+1, String.length(line)))
      newBoard= Map.replace(boardMap,:board, b)
      newPiece = Map.replace(pieceMap,:points, t)
      if(length(t) > 0) do
        placeOnBoard(newPiece, newBoard,state)
      else
        boardM = Map.replace(newBoard,:count,Map.get(newBoard,:count)+1)
        boardP = rowClear(boardM)
        boardL = checkPowerup(Map.get(pieceMap, :points), boardP)
      end
    else
      boardMap
    end
  end
  def drop(point,board,false)do

    newPoint=Enum.map(point, fn([x,y]) -> [x+1,y]end)

    if (fillTest(newPoint,board) == true)do
      drop(newPoint,board,:false)
    else
      drop(newPoint,board,:true)
    end
  end
  def drop(point,_,:true) do
      Enum.map(point, fn([x,y]) -> [x-1,y]end)
  end
  def fillTest(points,board) do
    Enum.all?(points, fn (n) -> getBoard(n,board) == " " or getBoard(n,board) == "x" end)
  end
  def getBoard([x,y],board) do
    row = Enum.at(board, x )
    character = String.at(row, y)
  end
  def increaseRotation(rotation)do
    rot=
      if (rotation == 4) do
        0
      else
        rotation
      end
      rem(rot+1,5)
  end
  def decreaseRotation(rotation)do
    rot=
      if (rotation == 1) do
        5
      else
        rotation
      end
    rem(rot-1,5)
  end
  def doCommand(["moves"|list1],{:game,board,dice,piece,state})do
    result=
    if (state ==true)do
        a=""
        list = List.to_string(list1)


        [newPiece2,newDice,newState] =
          if(piece==nil)do
              [newPiece,newDice] =createBlocks(dice,board)
              p2 = Map.get(newPiece,:temp)

              if (fillTest(p2,Map.get(board,:board)) == true ) do
                [Map.put(newPiece, :points, p2),newDice,state]
              else
                [newPiece,newDice,false]
              end
          else
            [piece,dice,state]
          end



        endResult =
          if (newState == true and String.length(list)!=0 and state != false)do
                [newPiece3,newBoard3,newDice3] = action(newPiece2,board,list,newDice,newState)
                {:game,newBoard3,newDice3,newPiece3,state}
          else

                if(Map.has_key?(newPiece2, :points) and state != false)do
                    #place it on the board
                    board2 = placeOnBoard(newPiece2, board,newState)

                    {:game,board2,newDice,nil,false}
                else
                    {:game,board,newDice,nil,false}
                end
          end
      endResult
    else
      {:game,board,dice,piece,false}
    end
    {:game,b,d,p,s}=result
    result
  end

  def checkPowerup(points, boardMap)do

    list = Map.get(boardMap, :powerup)
    if (list != nil)do

      board = Map.get(boardMap, :board)

      if((Enum.zip(points, list)|>Enum.any?(fn {[x,y],[a,b]} -> x==a and y==b end)) == true)do

        [h|t] = Enum.reverse(board)
        boardSize = length(board)
        index = findIndex(t,1,boardSize)

        if ( index != -1) do

          newBoard = powerClear(boardMap, index)
        else
          boardMap
        end

      else
        boardMap
      end

    else
      boardMap
    end
  end

  def findIndex([h|t], index,boardSize)do

    line = String.graphemes(h)
    mapList = Enum.reduce(line, %{}, fn(letter, map) ->
      Map.update(map, letter, 1, &(&1 + 1))end)
    count = Map.get(mapList," ")

    if ( index == boardSize-1)do
      -1
    else
      if ( count == 3) do
        index

      else
        findIndex(t,index+1,boardSize)
      end
    end
  end


  def clearRowTest([firstRow|rest],index,boardSize) do
    #needs to recieve a backwards board
    #will return true if the row needs to be cleared and then shifted
    line = String.graphemes(firstRow)
    mapList = Enum.reduce(line, %{}, fn(letter, map) -> Map.update(map, letter, 1, &(&1 + 1))end)
    ans= Enum.any?(Map.keys(mapList), fn(n) -> n == " " end)
    if ( index == boardSize-1)do
      -1
    else
      if ( ans == false) do
        index
      else
        clearRowTest(rest,index+1,boardSize)
      end
    end
  end


  def rowClear(board)do
    board2= Map.get(board, :board)
    [firstRow|rest] = Enum.reverse(board2)      #this is the entire board, in reverse without the bottom
    col = Map.get(board, :col)
    boardSize = length(board2)
    index = clearRowTest(rest,1,boardSize)    #this will return the index of the row that is filled

    boardMap2 =newBoardCreator(board, index, col)
  end

  def newBoardCreator(board, index, col)do
    if ( index != -1) do
      boar = Enum.reverse(Map.get(board, :board))
      h =Enum.slice(boar, 0,index)
      b= Enum.slice(boar, index+1,length(boar))
      newBoard = shift(h,b,col)
      newBoardMap = Map.replace(board, :board, newBoard)

      newIndex = rowClear(newBoardMap)
      #newBoardCreator(newBoard, newIndex,col)

    else
      board
    end
  end

  def shift(newBoard, [h|t],column)do
    board = List.insert_at(newBoard,length(newBoard),h)
    if(length(t)>0 )do
      shift(board,t,column)
    else
      Enum.reverse(List.insert_at(board,length(board),"|" <> String.duplicate(" ", column) <> "|\n"))
    end
  end

  def powerClear(boardB,index)do
    board = Map.get(boardB, :board)
    col = Map.get(boardB,:col)
    powerPoints=Map.get(boardB,:powerup)
    oldBoard = Enum.reverse(Enum.map(board, fn(n) -> String.replace(n,"x"," ") end))
    h = Enum.slice(oldBoard,0,index)
    b = Enum.slice(oldBoard, index+1, length(oldBoard)-1)
    newBoard = shift(h,b,col)
    board2 = Map.put(boardB, :board, newBoard)
    newBoard2= powerPlace(powerPoints, board2)
    newBoard2
  end

    def powerPlace(points, board) do
      [h|t] = points
      newB = placePowerup(h,board)
      if(length(t) != 0) do
        powerPlace(t,newB)
      else newB
      end
    end

  def placePowerup([r,c], b)do
    board = Map.get(b,:board)
    width = c
    rows = r
    line = Enum.at(board,rows)
    newB = List.replace_at(board,rows,String.slice(line,0, width-1) <> "x" <> String.slice(line, width, String.length(line)))
    Map.replace(b, :board, newB)
  end
  def action(pieceMap, boardMap,list,dice,state) do

    if (Map.get(pieceMap, :points)!= false and state != false) do

    board = Map.get(boardMap, :board)
    command = String.at(list,0)
    rot = Map.get(pieceMap, :rot)
    p= Map.get(pieceMap, :points)
    type = Map.get(pieceMap, :type)
    [pX,pY] = Enum.at(p,0)


    [point, rotation] =
    case command do
      "l" -> [Enum.map(p, fn([x,y]) -> [x,y-1] end),rot]
      "r" -> [Enum.map(p, fn([x,y]) -> [x,y+1]end),rot]
      "." -> [Enum.map(p, fn([x,y]) -> [x+1,y]end),rot]
      "R" ->
        if (type == "y") do [p,rot]
        else [Enum.map(p, fn[x,y] -> [(y-pY) + pX , -(x-pX)+pY] end),increaseRotation(rot)]
        end
      "L" ->
        if (type == "y") do [p,rot]
      else [Enum.map(p, fn[x,y] -> [-(y-pY) + pX , (x-pX)+pY] end),decreaseRotation(rot)]
        end
      "+" -> [drop(p,board,false),rot]
    end

    map2 = Map.replace(pieceMap, :temp, point)
    map3 = Map.replace(map2, :rot, rotation)


    [newBoard1,newPiece1, newDice1,newState] =
      if (fillTest(point,board) == true) do
        [boardMap, Map.replace(map3,:points,point),dice,state]
      else
        if (command == ".") do
          frozen(map3,boardMap,dice,state)
        else
          if (command == "+")do
            map4 = Map.replace(map3, :temp,false)
            map5 = Map.replace(map4, :points,false)
            [boardMap, map5,dice,false]
          else
            [boardMap, map3,dice,state]
          end
        end
      end

    [newBoard,newPiece, newDice,newState2] =
      if ( command == "+") do
        frozen(newPiece1,newBoard1,newDice1,newState)
      else
        [newBoard1,newPiece1,newDice1,newState]
      end

    if (String.length(String.slice(list, 1, String.length(list)-1)) != 0 and newState2 != false) do
      action(newPiece, newBoard, String.slice(list, 1, String.length(list)-1),newDice,newState2)
    else
      [newPiece,newBoard,newDice]
    end
    else
    [pieceMap, boardMap,dice]
    end
  end
  def frozen(pieceMap,boardMap, diceMap,state)do
    b = placeOnBoard(pieceMap, boardMap,state)
    [p,d] = createBlocks(diceMap,boardMap)
    newPiece = Map.put(p, :points, Map.get(p,:temp))
    [b,newPiece,d,state]
  end
  def doCommand(["powerup",c,r],{:game,b,d,piece,state})do

    width = to_integer(c)
    rows = to_integer(r)
    board = Map.get(b,:board)
    width = to_integer(c)
    rows = to_integer(r)
    line = Enum.at(board,length(board)-rows-1)
    newB = List.replace_at(board,length(board)-rows-1,String.slice(line,0, width) <> "x" <> String.slice(line, width+1, String.length(line)))
    newBoard = Map.replace(b, :board, newB)
    newBoard1=
      if(Map.get(newBoard,:powerup)==nil)do
        map1 = Map.delete(newBoard,:powerup)
        Map.put(map1,:powerup,[[length(board)-rows-1,width+1]])
      else
        list= Map.get(newBoard,:powerup)
        newList = List.insert_at(list, 0, [length(board)-rows-1,width])
          Map.replace(newBoard,:powerup,newList)
      end
    {:game,newBoard1,d,piece,state}
  end


end
