--[[
	This module is meant as a template for any data you are wanting to store and change in the server.
]]

----- Loaded Modules -----

local Remotes = game.ReplicatedStorage:WaitForChild("RemoteMessages")

----- Private Variables -----

local defaultData = {
	["Template"] = 5,
}
-- WARNING MAKE SURE THE KEYS ARE DIFFERENT FROM ANY OTHER DEFAULT OR TEMP DATA
--[[
	 TempData can be utilized as global data. Where every player's TempData variable is the same
	 Meaning that you can set the tempData value whenever you want and every player joining will have the new data.
	 Ex:
		 GameMode = "Intermission" -- Start value
		 -- 1 minute late the fight starts
		 GameModeHandler:SetGameMode("Battle") -- This function will set the GameMode variable's value to "Battle" and update it for every player
													 utilizing the _UpdateAll() function
		 -- Now every player that joins will automatically have their GameMode variable set to "Battle" until changed
]]
local tempData = {
	["TempData"] = 10
}

----- Public Variables -----

local Template = {}
Template.__index = Template
----- Private Functions -----

--[[
	WARNING: THIS FUNCTION IS REQUIRED IF YOU WANT IT TO BE A PART OF THE DEFAULT DATA STRUCTURE
	Description:
		Function that returns the name and default data for this data type
]]
function Template:_GetDefaultData()
	return defaultData
end


--[[
	WARNING: THE DATA PASSED FROM HERE MUST NOT HAVE THE SAME NAME AS ANY OTHER DEFAULT OR TEMP DATA
	Description:
		Function that returns the name and default data for each data type the won't be saved
]]
function Template:_GetTempData()
	return tempData
end

--[[
	Description:
		Function called when the data of a player's profile is changed.
		Fires the UpdatePlayerEv function with the data name, and newData value
]]
local function _Update(plr, dataName, newData)
	Remotes.UpdatePlayerDataEv:FireClient(plr, dataName, newData)
end

--[[
	Description:
		Function called when the data of all players' profiles are changed.
			Main use is for Global Data changes as metioned above for tempData.
		Fires the UpdatePlayerEv function with the data name, and newData value.
]]
local function _UpdateAll(dataName, newData)
	Remotes.UpdatePlayerDataEv:FireAllClients(dataName, newData)
end

----- Public Functions -----

--[[
	Description:
		Function that checks if the given profile's Template data is
			equal to otherData.
]]
function Template:TemplateFunc(plr, profile, otherData)
	-- Get the profile's Data
	local data = profile.Data
	-- Compare the Template index's value to otherData
	if data.Template == otherData then
		print(plr)
	end
end

--[[
	Function to add a value to the player's Template value and update it
]]
function Template:AddToTemplate(plr, profile, amt)
	-- Get the profile's Data
	local data = profile.Data
	-- Increment the Template index in data by amt
	data.Template = data.Template + amt
	-- Fire to the client that its "Template" value was changed
	_Update(plr, "Template", data.Template)
end

--[[
	Function that is passed a table of players indexed numerically and prints out if
	the currently checked player's Val is greater than the previously check player's Val
]]
function Template:ComparePlayers(plrs, profiles)
	local prevPlr,prevData = false, false

	-- Iterrate through all players
	for _,plr in pairs(plrs) do
		-- Get the player's profile data
		local data = profiles[plr].Data

		if not prevPlr and not prevData then
			prevPlr = plr
			prevData = data
		else
			if data.Val > prevData.Val then
				print(plr.Name .. " has a higher value than " .. prevPlr.Name)
			end
		end
	end
end

--[[
	Function that generates a random number between startVal and endVal
]]
function Template:GenerateNewNumber(min, max)
	return math.random(min, max)
end

----- Initiate -----

return Template
