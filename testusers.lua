-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local myData = require("mydata")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local kii = require("kii")

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	local testSignUpSignIn, testSignIn
	
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
print("userDeleteHandler: ", inspect(response))
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
	
--[[
	Test Output
--]]
	local testOutputGroup = display.newGroup()

	txtbResults = native.newTextBox( 10, 70, 300, 370 )
	
	group:insert( testOutputGroup )
-- --------------------------------------------------------------

	--testSignUpSignIn( {testUser="tedtester02", testPassword="ABC123", testEmail="ted02@tester.com"} )
	
	--testSignIn( {username="tedtester01", password="ABC123"} )
	
	--testSignInDelete( {testUser="tedtester02", testPassword="ABC123"} )
	
-- --------------------------------------------------------------

	
--[[
	SignIn user and Change User Password
--]]
	--kii.userSignIn( {username="tedtester01", password="ABC123"} )
	--kii.userPassword( "vJSoF43za19z5TG2v_O361T068e1rhKIKXFAyywXn-k", {newPassword="123ABC",oldPassword="ABC123"} )
	
-- --------------------------------------------------------------
	
--[[
	1) Setting user attributes upon sign-up, 2) SignIn user, 3) Getting user attributes
--]]
--[[
	local userSetAttrHandler, userSignInHandler, userGetAttrHandler
	
	function userGetAttrHandler( response )
print("userGetAttrHandler(): ", inspect(response) )
	end
	
	function userSignInHandler( response )
print("userSignInHandler(): ", inspect(response) )
		if not response.error then
			local userToken = response.access_token
			kii.userGetAttr( userToken, userGetAttrHandler )
		else
print(response.error_description)
		end
	end
	
	function userSetAttrHandler( response )
print("userSetAttrHandler()", inspect(response))
		kii.userSignIn( {username="tedtester03", password="ABC123"}, userSignInHandler )
	end
	kii.userSetAttr( {loginName="tedtester04", password="ABC123", displayName="tedtester04", country="JP", emailAddress="ted04@testkii.com", phoneNumber="+819098439218", followers=5, status="available"}, userSetAttrHandler)
--]]

-- --------------------------------------------------------------
	
--[[
	SignIn user, Delete User
--]]
--[[
	local userDeleteHandler, userSignInHandler
	
	local testUser = "tedtester02"
	local testPassword = "123ABC" 

	function userDeleteHandler( response )
print("userDeleteHandler(): ")
		if not (response == nil) then
print("USER "..testUser.." HAS BEEN DELETED")
		else
print(response.errorCode .. ": ", response.message)
		end
	end
	
	function userSignInHandler( response )
print("userSignInHandler(): ")

		if not response.errorCode then
			local userToken = response.access_token
			kii.userDelete( userToken, userDeleteHandler )
		else
print(response.errorCode .. ": ", response.error_description)
		end
	end
	kii.userSignIn( {username=testUser, password=testPassword}, userSignInHandler )
--]]
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
