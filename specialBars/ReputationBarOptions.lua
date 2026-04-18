--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")

local ReputationBarMod = Bartender4:GetModule("ReputationBar")

function ReputationBarMod:SetupOptions()
	if not self.options then
		-- NOTE: Shared lag-safe option builder lives in core Options.lua.
		self.optionobject, self.disabledoptions = Bartender4:CreateStatusBarOptionObject(
			self,
			L["Enable the Reputation Bar"],
			L["Show text on the Reputation Bar."]
		)

		self.optionobject:AddElement("text", "autohide", {
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

		self.options = {
			order = 32,
			type = "group",
			name = L["Reputation Bar"],
			desc = L["Configure the Reputation Bar"],
			childGroups = "tree",
		}
		Bartender4:RegisterBarOptions("ReputationBar", self.options)
	end

	self.options.args = self:IsEnabled() and self.optionobject.table or self.disabledoptions
end
