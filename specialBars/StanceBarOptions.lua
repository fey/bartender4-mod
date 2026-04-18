--[[ $Id: StanceBarOptions.lua 77829 2008-07-05 12:41:16Z nevcairiel $ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")

-- module
local StanceBarMod = Bartender4:GetModule("StanceBar")

-- fetch upvalues
local ButtonBar = Bartender4.ButtonBar.prototype

function StanceBarMod:SetupOptions()
	if not self.options then
		self.optionobject = ButtonBar:GetOptionObject()
		self.optionobject.table.general.args.rows.max = self.button_count
		local enabled = {
			type = "toggle",
			order = 1,
			name = L["Enabled"],
			desc = L["Enable the StanceBar"],
			get = function() return self.db.profile.enabled end,
			set = "ToggleModule",
			handler = self,
		}
		self.optionobject.table.enabled = enabled
		
		self.disabledoptions = {
			enabled = enabled,
		}
		
		self.options = {
			order = 30,
			type = "group",
			name = L["Stance Bar"],
			desc = L["Configure  the Stance Bar"],
			childGroups = "tree",
			disabled = function(info) return GetNumShapeshiftForms() == 0 end,
		}
		Bartender4:RegisterBarOptions("StanceBar", self.options)
	end
	self.options.args = self:IsEnabled() and self.optionobject.table or self.disabledoptions
end
