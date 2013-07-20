-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.HiddenStatusBar )

local myData 		= require "mydata"

local widget 		= require "widget"

local storyboard 	= require "storyboard"

local value 		= require "json"

local inspect 		= require "inspect"

local function doesFileExist( fname, path )

    local results = false

    local filePath = system.pathForFile( fname, path )

    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "r" )
    end

    if ( filePath ) then
        print( "File found: " .. fname )
        --clean up file handles
        filePath:close()
        results = true
    else
        print( "File does not exist: " .. fname )
    end

    return results
end

local function saveFile( fle, data )
	local path = system.pathForFile( fle, system.DocumentsDirectory )

	local file = io.open( path, "w" )

	file:write( data )

	io.close( file )
	
	file = nil
end
myData.saveFile = saveFile

local function readFile(fle)
	local path = system.pathForFile( fle, system.DocumentsDirectory )

	local file = io.open( path, "r" )
	local data = file:read( "*a" )

	io.close( file )
	file = nil
	
	return data
end
myData.readFile = readFile

--Setup the nav bar 
local navBar = display.newImage("navBar.png", 0, 0, true)
navBar.x = display.contentWidth*.5
navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)
myData.navBar = navBar

local navHeader = display.newText("CoronaKii", 0, 0, native.systemFontBold, 16)
navHeader:setTextColor(255, 255, 255)
navHeader.x = display.contentWidth*.5
navHeader.y = navBar.y
myData.navHeader = navHeader

storyboard.gotoScene("view1")
