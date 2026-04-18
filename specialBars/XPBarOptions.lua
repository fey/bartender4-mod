--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")

local XPBarMod = Bartender4:GetModule("XPBar")

function XPBarMod:SetupOptions()
	if not self.options then
		-- NOTE: Shared lag-safe option builder lives in core Options.lua.
		self.optionobject, self.disabledoptions = Bartender4:CreateStatusBarOptionObject(
			self,
			L["Enable the XP Bar"],
			L["Show text on the XP Bar."]
		)

		self.optionobject:AddElement("text", "showrested", {
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

		self.options = {
			order = 31,
			type = "group",
			name = L["XP Bar"],
			desc = L["Configure the XP Bar"],
			childGroups = "tree",
		}
		Bartender4:RegisterBarOptions("XPBar", self.options)
	end

	self.options.args = self:IsEnabled() and self.optionobject.table or self.disabledoptions
end
