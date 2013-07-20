value 	= require ("json")
inspect = require ("inspect")
	
return function(options)
	local self = {}
	
	if options.appID then
		self._APPID = options.appID
	end
	
	if options.appKey then
		self._APPKEY = options.appKey
	end
		
	-- Kii data fields
	local request = nil
	self.request = request

	local callback = nil
	self.callback = callback
		
	self._BASEURL		= "https://api.kii.com/api/apps/"
	self._OAUTHURL	= "https://api.kii.com/api/oauth2/token"
        
	--sign up with Kii.com to obtain Application ID and REST API Key
	local headers = {}
	headers["content-type"]		= nil
	headers["x-kii-appid"]		= _APPID
	headers["x-kii-appkey"]		= _APPKEY
	headers["Authorization"]	= nil

	local params = {}
	params.headers = headers
	
	--get from player input or local storage
	local AccountSetup = {
		username = nil,
		password = nil,
		email = nil
	}
	self.AccountSetup = AccountSetup

	local LocalAccount = {  	
		username = nil,
		password = nil,
		email = nil,
		emailVerified = false, 	-- read-only response field
		objectId = nil,        	-- read-only response field
		createdAt = nil,       	-- read-only response field
		updatedAt = nil,       	-- read-only response field
		sessionToken = nil,     -- read-only response field
		-- define additional fields as necessary
	}
	self.LocalAccount = LocalAccount
		
	--[[ ----------------------------------------------------
	--		Network Listener
	--]] ----------------------------------------------------
	local function networkListener( event )
		local response = nil
		
		callback( value.decode(event.response) )
	end
	
	--[[ ----------------------------------------------------
	--		USER METHODS
	--]] ----------------------------------------------------
	
	--[[ ----------------------------------------------------
		Create a user - userSignUp

		curl -v -X POST \
			-H "content-type:application/vnd.kii.RegistrationRequest+json" \
			-H "x-kii-appid:{APP_ID}" \
			-H "x-kii-appkey:{APP_KEY}" \
			"https://api.kii.com/api/apps/{APP_ID}/users" \
			-d '{"loginName":"user_123456", "displayName":"person test000", "country":"JP", "password":"123ABC"}'
	--]] ----------------------------------------------------
	local function userSignUp( obj, cb )
		if (not obj.loginName or not obj.password or not obj.email) then
print ("Missing login data")
		else
			callback = cb
	
			headers["content-type"]		= "application/vnd.kii.RegistrationRequest+json"
			headers["x-kii-appid"]		= self._APPID
			headers["x-kii-appkey"]		= self._APPKEY
					
			params.body = value.encode ( obj )
	
			request = "signup"
print( self._BASEURL .. self._APPID .. "/users" )
print(inspect(params))
			local url = self._BASEURL .. self._APPID .. "/users"
			network.request( url, "POST", networkListener,  params)
		end
	end
	self.userSignUp = userSignUp
	
	--[[ ----------------------------------------------------
		Sign in a user - userSignIn

		curl -v -X POST \
			-H "content-type:application/json" \
			-H "x-kii-appid:{APP_ID}" \
			-H "x-kii-appkey:{APP_KEY}" \
			"https://api.kii.com/api/oauth2/token" \
			-d '{"username":"user_123456", "password":"123ABC"}'
	--]] ----------------------------------------------------
	local function userSignIn( obj, cb )
		if (not obj.username or not obj.password) then
print ("Missing access token data")
		else
			callback = cb
			
			headers["content-type"]		= "application/json"
			headers["x-kii-appid"]		= self._APPID
			headers["x-kii-appkey"]		= self._APPKEY
			
			params.body = value.encode ( obj )
			
			request = "signin"
print(inspect(params))
			local url = self._OAUTHURL
print(url)
			network.request( url, "POST", networkListener,  params)
		end
	end
	self.userSignIn = userSignIn
	
	--[[ ----------------------------------------------------
		Change a user password - userPassword

		curl -v -X PUT \
		  -H "Authorization:Bearer {ACCESS_TOKEN}" \
		  -H "content-type:application/vnd.kii.ChangePasswordRequest+json" \
		  -H "x-kii-appid:{APP_ID}" \
		  -H "x-kii-appkey:{APP_KEY}" \
		  "https://api.kii.com/api/apps/{APP_ID}/users/me/password" \
		  -d '{"newPassword":{NEW_PASSWORD},"oldPassword":{OLD_PASSWORD}}'
	--]] ----------------------------------------------------
	local function userPassword( token, obj )
		if (not obj.newPassword and not obj.newPassword) then
print ("Missing access token data")
		else
			headers["Authorization"]	= "Bearer " .. token
			headers["content-type"]		= "application/vnd.kii.ChangePasswordRequest+json"
			
			params.body = value.encode ( obj )
			
			request = "password"
print(_BASEURL .. _APPID .. "/users/me/password")
print(inspect(params))
			network.request( _BASEURL .. _APPID .. "/users/me/password", "PUT", networkListener,  params)
		end
	end
	self.userPassword = userPassword
	  
	--[[ ----------------------------------------------------
		Set user attributes - userSetAttr

		curl -v -X POST \
			-H "content-type:application/json" \
			-H "x-kii-appid:{APP_ID}" \
			-H "x-kii-appkey:{APP_KEY}" \
			"https://api.kii.com/api/apps/{APP_ID}/users" \
			-d '{ \
				"loginName":"test004",\
				"displayName":"person test004",\
				"country":"JP", \
				"password":"hogehoge", \
				"emailAddress":"test004@testkii.com", \
				"phoneNumber":"+819098439216", \
				"followers":5, \
				"friends":400, \
				"status":"available" \
			}'
	--]] ----------------------------------------------------
	local function userSetAttr( obj, cb )
		if not (obj.loginName and obj.password) then
print ("Missing access token data")
		else
			callback = cb
			
			headers["content-type"]		= "application/json"
			
			params.body = value.encode ( obj )
			
			request = "setuser"

			network.request( _BASEURL .. _APPID .. "/users", "POST", networkListener,  params)
		end
	end
	self.userSetAttr = userSetAttr
	
	--[[ ----------------------------------------------------
		Set user attributes - userGetAttr

		curl -v -X GET \
			-H "Authorization:Bearer {ACCESS_TOKEN}" \
			-H "x-kii-appid:{APP_ID}" \
			-H "x-kii-appkey:{APP_KEY}" \
			"https://api.kii.com/api/apps/{APP_ID}/users/me"
	--]] ----------------------------------------------------
	local function userGetAttr( token, cb )
		if not (token) then
print ("Missing access token data")
		else
			callback = cb
			
			headers["Authorization"]	= "Bearer " .. token
			headers["content-type"]		= nil
			
			request = "getuser"

			network.request( _BASEURL .. _APPID .. "/users/me", "GET", networkListener,  params)
		end
	end
	self.userGetAttr = userGetAttr
	  
	--[[ ----------------------------------------------------
		Delete user - userDelete

		curl -v -X DELETE \
			-H "Authorization:Bearer {ACCESS_TOKEN}" \
			-H "x-kii-appid:{APP_ID}" \
			-H "x-kii-appkey:{APP_KEY}" \
			"https://api.kii.com/api/apps/{APP_ID}/users/me"
	--]] ----------------------------------------------------
	local function userDelete( token, cb )
		if not (token) then
print ("Missing access token data")
		else
			callback = cb
			
			headers["content-type"]		= nil
			headers["Authorization"]	= "Bearer " .. token
			headers["x-kii-appid"]		= self._APPID
			headers["x-kii-appkey"]		= self._APPKEY
			
			request = "deleteuser"

			local url = self._BASEURL .. self._APPID .. "/users/me"
			network.request( url, "DELETE", networkListener,  params)
		end
	end
	self.userDelete = userDelete
		
	--[[ ----------------------------------------------------
	--		LOCAL DEVICE METHODS
	--]] ----------------------------------------------------
	local function getStoredUsername ()
		local path = system.pathForFile( "usr.txt", system.DocumentsDirectory )
	
		-- io.open opens a file at path. returns nil if no file found
		local file, err = io.open( path, "r" )
	
		if (file) then
			local storedName = file:read( "*a" )
			return storedName
		else
			print ("Failed: ", err)
			return nil
		end
	
	end
	self.getStoredUsername = getStoredUsername
	
	return self
end