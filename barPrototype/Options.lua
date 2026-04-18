--[[ $Id: Options.lua 77829 2008-07-05 12:41:16Z nevcairiel $ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")
local Bar = Bartender4.Bar.prototype

--[[===================================================================================
	Bar Options
===================================================================================]]--

local barregistry = Bartender4.Bar.barregistry

-- option utilty functions
local optGetter, optSetter
do
	local getBar, optionMap, callFunc
	-- maps option keys to function names
	optionMap = {
		alpha = "ConfigAlpha",
		scale = "ConfigScale",
		show = "Show",
		fadeout = "FadeOut",
		fadeoutalpha = "FadeOutAlpha",
		fadeoutdelay = "FadeOutDelay",
		snapping = "Snapping",
		snapdistance = "SnapDistance",
		centersnapdistance = "CenterSnapDistance",
		snappadding = "SnapPadding",
		clamptoscreen = "ClampToScreen",
	}
	
	-- retrieves a valid bar object from the barregistry table
	function getBar(id)
		local bar = barregistry[tostring(id)]
		assert(bar, ("Invalid bar id in options table. (%s)"):format(id))
		return bar
	end
	
	-- calls a function on the bar
	function callFunc(bar, type, option, ...)
		local func = type .. (optionMap[option] or option)
		assert(bar[func], ("Invalid get/set function %s in bar %s."):format(func, bar.id))
		return bar[func](bar, ...)
	end
	
	-- universal function to get a option
	function optGetter(info)
		local bar = getBar(info[2])
		local option = info[#info]
		return callFunc(bar, "Get", option)
	end
	
	-- universal function to set a option
	function optSetter(info, ...)
		local bar = getBar(info[2])
		local option = info[#info]
		return callFunc(bar, "Set", option, ...)
	end
end

local showOptions = { alwaysshow = L["Always Show"], alwayshide = L["Always Hide"], combatshow = L["Show in Combat"], combathide = L["Hide in Combat"] }

local options
function Bar:GetOptionObject()
	local otbl = {
		general = {
			type = "group",
			cmdInline = true,
			name = L["General Settings"],
			order = 1,
			args = {
				show = {
					order = 5,
					type = "select",
					name = L["Show/Hide"],
					desc = L["Configure when to Show/Hide the bar."],
					get = optGetter,
					set = optSetter,
					values = showOptions,
				},
				styleheader = {
					order = 10,
					type = "header",
					name = L["Bar Style & Layout"],
				},
				alpha = {
					order = 20,
					name = L["Alpha"],
					desc = L["Configure the alpha of the bar."],
					type = "range",
					min = .1, max = 1, bigStep = 0.1,
					get = optGetter,
					set = optSetter,
				},
				scale = {
					order = 30,
					name = L["Scale"],
					desc = L["Configure the scale of the bar."],
					type = "range",
					min = .1, max = 2, step = 0.05,
					get = optGetter,
					set = optSetter,
				},
				fadeout = {
					order = 100,
					name = L["Fade Out"],
					desc = L["Enable the FadeOut mode"],
					type = "toggle",
					get = optGetter,
					set = optSetter,
					width = "full",
				},
				fadeoutalpha = {
					order = 101,
					name = L["Fade Out Alpha"],
					desc = L["Enable the FadeOut mode"],
					type = "range",
					min = 0, max = 1, step = 0.05,
					get = optGetter,
					set = optSetter,
					disabled = function(info) return not barregistry[info[2]]:GetFadeOut() end,
				},
				fadeoutdelay = {
					order = 102,
					name = L["Fade Out Delay"],
					desc = L["Enable the FadeOut mode"],
					type = "range",
					min = 0, max = 1, step = 0.01,
					get = optGetter,
					set = optSetter,
					disabled = function(info) return not barregistry[info[2]]:GetFadeOut() end,
				},
			},
		},
		align = {
			type = "group",
			cmdInline = true,
			name = L["Alignment"],
			order = 10,
			args = {
				snapping = {
					order = 1,
					type = "toggle",
					name = L["Enable Snapping"],
					desc = L["Enable snapping while dragging."],
					get = optGetter,
					set = optSetter,
					width = "full",
				},
				snapdistance = {
					order = 10,
					type = "range",
					name = L["Snap Distance"],
					desc = L["Distance in pixels used for edge snapping."],
					min = 0, max = 40, step = 1,
					get = optGetter,
					set = optSetter,
					disabled = function(info)
						local bar = barregistry[info[2]]
						return not (bar and bar:GetSnapping())
					end,
				},
				centersnapdistance = {
					order = 20,
					type = "range",
					name = L["Center Snap Distance"],
					desc = L["Distance in pixels used for center alignment snapping."],
					min = 0, max = 60, step = 1,
					get = optGetter,
					set = optSetter,
					disabled = function(info)
						local bar = barregistry[info[2]]
						return not (bar and bar:GetSnapping())
					end,
				},
				snappadding = {
					order = 30,
					type = "range",
					name = L["Snap Padding"],
					desc = L["Additional gap between bars when edge snapping."],
					min = -20, max = 40, step = 1,
					get = optGetter,
					set = optSetter,
					disabled = function(info)
						local bar = barregistry[info[2]]
						return not (bar and bar:GetSnapping())
					end,
				},
				clamptoscreen = {
					order = 40,
					type = "toggle",
					name = L["Clamp to Screen"],
					desc = L["Keep bar inside screen bounds while moving."],
					get = optGetter,
					set = optSetter,
					width = "full",
				},
			},
		}
	}
	return Bartender4:NewOptionObject(otbl)
end
