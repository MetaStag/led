--[[
    led
    ed clone written in lua
--]]

-- Intro
print('led')
print('-----')

-- Variables
fileName = ''
fileTable = {}
undoBuffer = {}
yankBuffer = ''
lineNum = 0
saved = true

-- Functions
function fileExists(name) -- Check if file exists
    local file = io.open(name, 'r')
    if file == nil then
        return false
    else
        file:close()
        return true
    end
end

function write() -- Write to file
    local file = io.open(fileName, 'w')
    for i = 1, #fileTable do -- writing the contents of fileTable to the file
        file:write(fileTable[i]..'\n')
    end
    file:close()
    saved = true
end

-- Main Loop
while true do
    io.write(lineNum..' > ')
    command = io.read()
    command = string.lower(command) -- To manage case-sensitivity

    if command == '[' or command == '(' then -- These symbols cause problems later
        print('~~ ?')

    elseif command == 'clear' then -- Clear Screen
        os.execute('clear')

    elseif string.find(command, 'e') then -- Open file
        if #command < 3 or command:sub(2, 2) ~= ' ' then
            print('~~ Invalid syntax')
        else
            fileName = command:sub(3)
            if fileExists(fileName) then
                print('~~ Opening '..fileName..'...')
                file = io.open(fileName, 'r')
                for line in file:lines() do -- import all lines to fileTable
                    table.insert(fileTable, line)
                end
                lineNum = 1
            else -- if file doesn't exist, make it
                print('~~ Creating '..fileName..'...')
                file = io.open(fileName, 'w+')
            end

            file:close() -- closing the file as we'll be interacting with the fileTable, not the actual file
        end

    elseif string.find(command, 'f') then -- Set filename
        if #command < 3 or command:sub(2, 2) ~= ' ' then
            print('~~ Invalid syntax')
        else
            if fileName == '' then -- Make a new file if it doesn't exist
                print('~~ Creating a new file and naming it '..command:sub(3)..'...')
                file = io.open(command:sub(3), 'w')
                file:close()
            else
                print('~~ Renaming '..fileName..' to '..command:sub(3)..'...')
                os.rename(fileName, command:sub(3))
            end
            fileName = command:sub(3)
        end

    elseif command == 'x' then -- Close file
        if fileName == '' then
            print('~~ No files are opened right now...')
        else
            if not saved then
                print('~~ You still have unsaved changes, saving them and exiting the file...')
                write()
            else
                print('~~ Closing '..fileName..'...')
            end
            fileName = ''
            fileTable = {}
            lineNum = 0
            saved = true
        end

    elseif type(tonumber(command)) == 'number' then -- Go to a different line
        command = tonumber(command)
        if command > #fileTable then
            print('~~ The file only has '..#fileTable..' line(s)!')
        else
            print('~~ Moving to line '..command)
            lineNum = command
        end

    elseif string.find(command, 'a') then -- Add line
        if type(tonumber(command:sub(1, string.find(command, 'a')-1))) == 'number' then
            num = tonumber(command:sub(1, string.find(command, 'a')-1))
            if num > #fileTable then
                print('~~ The file only has '..#fileTable..' line(s)!')
                flag = false -- Don't execute the command
            else
                flag = true
            end
        else
            num = lineNum
            lineNum = lineNum + 1
            flag = true

        end

        if flag then
            line = io.read() 
            table.insert(fileTable, num+1, line)
            undoBuffer = {}
            table.insert(undoBuffer, 'a')
            table.insert(undoBuffer, num+1)
            saved = false
        end

    elseif string.find(command, 'c') then -- Change line
        if lineNum == 0 then
            print('~~ The buffer is empty')
        else
            if type(tonumber(command:sub(1, string.find(command, 'c')-1))) == 'number' then
                num = tonumber(command:sub(1, string.find(command, 'c')-1))
                if num > #fileTable then
                    print('~~ The file only has '..#fileTable..' line(s)!')
                    flag = false -- Don't execute the command
                else
                    flag = true
                end
            else
                num = lineNum
                flag = true
            end
        end

        if flag then
            line = io.read() 
            undoBuffer = {}
            table.insert(undoBuffer, 'c')
            table.insert(undoBuffer, num)
            table.insert(undoBuffer, fileTable[num])
            table.remove(fileTable, num)
            table.insert(fileTable, num, line)
            saved = false
        end

    elseif string.find(command, 'd') then -- Delete line
        if lineNum == 0 then
            print('~~ The buffer is empty')
        else
            if type(tonumber(command:sub(1, string.find(command, 'd')-1))) == 'number' then
                num = tonumber(command:sub(1, string.find(command, 'd')-1))
                if num > #fileTable then
                    print('~~ The file only has '..#fileTable..' line(s)!')
                    flag = false -- Don't execute the command
                else
                    flag = true
                end
            else
                num = lineNum
                flag = true
            end
        end

        if flag then
            print('~~ Deleting line '..num)
            table.remove(fileTable, num)
            undoBuffer = {}
            table.insert(undoBuffer, 'd')
            table.insert(undoBuffer, num)
            table.insert(undoBuffer, fileTable[num])

            if #fileTable < lineNum then
                lineNum = lineNum - 1
            end
            saved = false
        end

    elseif string.find(command, 'y') then -- Yank line
        if lineNum == 0 then
            print('~~ The buffer is empty')
        else
            if type(tonumber(command:sub(1, string.find(command, 'y')-1))) == 'number' then
                num = tonumber(command:sub(1, string.find(command, 'y')-1))
                if #fileTable < num then
                    print('~~ The file only has '..#fileTable..' line(s)!')
                    flag = false -- Don't execute the command
                else
                    flag = true
                end
            else
                num = lineNum
                flag = true
            end
            if flag then
                print('~~ Yanking line')
                yankBuffer = fileTable[num] 
            end
        end

    elseif string.find(command, 'p') then -- Paste line
        if yankBuffer == '' then
            print('~~ The yank buffer is empty...')
        else
            if type(tonumber(command:sub(1, string.find(command, 'p')-1))) == 'number' then
                num = tonumber(command:sub(1, string.find(command, 'p')-1))
                if num > #fileTable then
                    print('~~ The file only has '..#fileTable..' line(s)!')
                    flag = false -- Don't execute the command
                else
                    flag = true
                end
            else
                num = lineNum
                flag = true
            end
            if flag then
                print('-- Pasting the yank buffer...')
                table.insert(fileTable, num+1, yankBuffer)
                undoBuffer = {}
                table.insert(undoBuffer, 'a')
                table.insert(undoBuffer, num+1)
                saved = false
            end
        end

    elseif command == 'u' then -- Undo
        if undoBuffer[1] == 'a' then -- Undo add/paste line
            table.remove(fileTable, undoBuffer[2])
            if #fileTable < lineNum then
                lineNum = lineNum - 1
            end
            print('~~ Removed line '..undoBuffer[2])
        elseif undoBuffer[1] == 'c' then -- Undo change line
            table.remove(fileTable, undoBuffer[2])
            table.insert(fileTable, undoBuffer[2], undoBuffer[3])
            print("~~ Changed line "..undoBuffer[2].." back to it's previous state")
        elseif undoBuffer[1] == 'd' then -- Undo delete line
            table.insert(fileTable, undoBuffer[2], undoBuffer[3])
            print('~~ Readded line '..undoBuffer[2])
        end
        undoBuffer = {}
        saved = false

    elseif command == '.' then -- See current line
        if lineNum == 0 then
            print('~~ The buffer is empty')
        else
            print(lineNum..' | '..fileTable[lineNum])
        end

    elseif command == '=' then -- See all lines
        if lineNum == 0 then
            print('~~ The buffer is empty')
        else
            for i = 1, #fileTable do
                print(i..' | '..fileTable[i])
            end
        end

    elseif string.find('wq!', command) then -- Write/Quit
        if string.find(command, 'w') then
            if fileName == '' then
                io.write('~~ No files in buffer\nGive a file name: ')
                fileName = io.read()
            end
            print('~~ Writing changes...')
            write()
        end

        if string.find(command, 'q') then
            if string.find(command, '!') or saved then
                print('Sayonara...')
                break
            else
                print('~~ You still have unsaved changes! Do q! to force quit')
            end
        end
    else -- Invalid Command
        print('~~ ?')
    end
end
