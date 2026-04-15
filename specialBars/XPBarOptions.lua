--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")

local XPBarMod = Bartender4:GetModule("XPBar")
local Bar = Bartender4.Bar.prototype

function XPBarMod:SetupOptions()
	if not self.options then
		self.optionobject = Bar:GetOptionObject()

		local enabled = {
			type = "toggle",
			order = 1,
			name = L["Enabled"],
			desc = L["Enable the XP Bar"],
			get = function() return self.db.profile.enabled end,
			set = "ToggleModule",
			handler = self,
		}
		self.optionobject:AddElement("general", "enabled", enabled)

		self.optionobject:AddElement("general", "showtext", {
			type = "toggle",
			order = 81,
			name = L["Show Text"],
			desc = L["Show text on the XP Bar."],
			get = function() return self.db.profile.showtext end,
			set = function(info, value)
				self.db.profile.showtext = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "showrested", {
			type = "toggle",
			order = 82,
			name = L["Show Rested"],
			desc = L["Show rested XP text on the XP Bar."],
			get = function() return self.db.profile.showrested end,
			set = function(info, value)
				self.db.profile.showrested = value
				self:ApplyConfig()
			end,
			disabled = function() return not self.db.profile.showtext end,
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
			order = 31,
			type = "group",
			name = L["XP Bar"],
			desc = L["Configure the XP Bar"],
			childGroups = "tab",
		}
		Bartender4:RegisterBarOptions("XPBar", self.options)
	end

	self.options.args = self:IsEnabled() and self.optionobject.table or self.disabledoptions
end
