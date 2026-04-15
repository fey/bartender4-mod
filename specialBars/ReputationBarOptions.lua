--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")

local ReputationBarMod = Bartender4:GetModule("ReputationBar")
local Bar = Bartender4.Bar.prototype

function ReputationBarMod:SetupOptions()
	if not self.options then
		self.optionobject = Bar:GetOptionObject()

		local enabled = {
			type = "toggle",
			order = 1,
			name = L["Enabled"],
			desc = L["Enable the Reputation Bar"],
			get = function() return self.db.profile.enabled end,
			set = "ToggleModule",
			handler = self,
		}
		self.optionobject:AddElement("general", "enabled", enabled)

		-- Bar Width (order 40)
		self.optionobject:AddElement("general", "width", {
			type = "range",
			order = 40,
			name = L["Bar Width"],
			desc = L["Set the width of the bar."],
			min = 100,
			max = 800,
			step = 10,
			get = function() return self.db.profile.width end,
			set = function(info, value)
				self.db.profile.width = value
				self:ApplyConfig()
			end,
		})

		-- Bar Height (order 50)
		self.optionobject:AddElement("general", "height", {
			type = "range",
			order = 50,
			name = L["Bar Height"],
			desc = L["Set the height of the bar."],
			min = 5,
			max = 50,
			step = 1,
			get = function() return self.db.profile.height end,
			set = function(info, value)
				self.db.profile.height = value
				self:ApplyConfig()
			end,
		})

		-- Bar Texture (order 60)
		local barTextures = {
			["Interface\\TARGETINGFRAME\\UI-StatusBar"] = "Standard",
			["Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill"] = "Raid",
			["Interface\\CASTINGBAR\\UI-CastingBar-Standard"] = "Casting",
			["Interface\\PAPERDOLLINFOFRAME\\UI-Character-Skills-Bar"] = "Skills",
			["Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill"] = "Targeting",
		}

		self.optionobject:AddElement("general", "texture", {
			type = "select",
			order = 60,
			name = L["Bar Texture"],
			desc = L["Select the texture for the bar."],
			values = barTextures,
			get = function() return self.db.profile.texture end,
			set = function(info, value)
				self.db.profile.texture = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "showtext", {
			type = "toggle",
			order = 81,
			name = L["Show Text"],
			desc = L["Show text on the Reputation Bar."],
			get = function() return self.db.profile.showtext end,
			set = function(info, value)
				self.db.profile.showtext = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "autohide", {
			type = "toggle",
			order = 82,
			name = L["Auto Hide"],
			desc = L["Hide the Reputation Bar when no faction is watched."],
			get = function() return self.db.profile.autohide end,
			set = function(info, value)
				self.db.profile.autohide = value
				self:ApplyConfig()
			end,
		})

		self.disabledoptions = {
			general = {
				type = "group",
				name = L["General Settings"],
				cmdInline = true,
				order = 1,
				args = {
					enabled = enabled,
				}
			}
		}

		self.options = {
			order = 32,
			type = "group",
			name = L["Reputation Bar"],
			desc = L["Configure the Reputation Bar"],
			childGroups = "tab",
		}
		Bartender4:RegisterBarOptions("ReputationBar", self.options)
	end

	self.options.args = self:IsEnabled() and self.optionobject.table or self.disabledoptions
end
