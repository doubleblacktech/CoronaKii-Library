-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local myData = require("mydata")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	kii = require "kii" {
		appID = "6d1a100b";								-- INSERT YOUR APPID HERE
		appKey = "871a8ae084e511142d598b9ec79d0a75";	-- INSERT YOUR APPKEY HERE
	}
	
	-- Forward function references
	local testSignUpSignIn, testSignIn
	
	-- Forward display object references
	local txtbResults
	
	local function printtb( ... )
		for i,v in ipairs(arg) do
			txtbResults.text = txtbResults.text .. tostring(v) .. "\n"
		end
	end
		
--[[
	testSignUpSignIn() - SignUp User, SignIn user
--]]
	function testSignUpSignIn( obj )
		local userSignUpHandler, userSignInHandler
		
		printtb("testSignUpSignIn()\n")
		
		function userSignInHandler( response )
			if not response.errorCode then
				printtb("response.access_token: " .. response.access_token)
			else
				printtb("response.errorCode: " .. response.error_description)
			end
		end
		
		function userSignUpHandler( response )
			if not response.errorCode then
				kii.userSignIn( {username=obj.testUser, password=obj.testPassword}, userSignInHandler )
			else
				printtb("response.errorCode: " .. response.message)
			end
		end
		kii.userSignUp( {loginName=obj.testUser, password=obj.testPassword, email=obj.testEmail}, userSignUpHandler )
	end
		
--[[
	testSignIn() - SignIn User
--]]
	function testSignIn( obj )
		local userSignInHandler
		
		printtb("testSignIn()\n")
		
		function userSignInHandler( response )
			if not response.errorCode then
				local userToken = response.access_token
				
				printtb("userToken: " .. userToken)
			else
				printtb("response.errorCode: " .. response.error_description)
			end
		end
		kii.userSignIn( obj, userSignInHandler )
	end
	
--[[
	testSignInDelete() - SignIn User, Delete User
--]]
	function testSignInDelete( obj )
		local userDeleteHandler, userSignInHandler
	
		printtb("testSignInDelete()\n")
		
		function userDeleteHandler( response )
			if response == nil then
				printtb("USER " .. obj.testUser .. " HAS BEEN DELETED")
			else
				printtb("response.errorCode: " .. response.message)
			end
		end
		
		function userSignInHandler( response )
			if not response.errorCode then
				local userToken = response.access_token
				
				printtb("userToken: " .. userToken)
				
				kii.userDelete( userToken, userDeleteHandler )
			else
				printtb("response.errorCode: " .. response.error_description)
			end
		end
		kii.userSignIn( {username=obj.testUser, password=obj.testPassword}, userSignInHandler )
	end
	
-- --------------------------------------------------------------

	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 200 )
	group:insert( bg )
	
	-- create a textbox to show Kii API responses
	local testOutputGroup = display.newGroup()
	txtbResults = native.newTextBox( 10, 70, 300, 400 )
	group:insert( testOutputGroup )
	
-- --------------------------------------------------------------

	--testSignUpSignIn( {testUser="tedtester08", testPassword="ABC123", testEmail="ted08@tester.com"} )
	
	--testSignIn( {username="tedtester08", password="ABC123"} )
	
	--testSignInDelete( {testUser="tedtester03", testPassword="ABC123"} )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	local previous_scene_name = storyboard.getPrevious()
	if previous_scene_name ~= nil then
		storyboard.removeScene( previous_scene_name )
	end
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc.)
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
