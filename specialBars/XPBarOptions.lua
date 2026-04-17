--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")

local XPBarMod = Bartender4:GetModule("XPBar")

function XPBarMod:SetupOptions()
	if not self.options then
		-- NOTE: We build XP options from a module-local option tree instead of
		-- inheriting Bar:GetOptionObject(). The inherited path caused severe UI
		-- stutter and incomplete first render in the XP/Reputation config pages.
		-- Keeping local get/set/disabled handlers preserves functionality and
		-- avoids the AceConfig callback path that triggered those lag spikes.
		self.optionobject = Bartender4:NewOptionObject({
			general = {
				type = "group",
				cmdInline = true,
				name = L["General Settings"],
				order = 1,
				args = {
					styleheader = {
						order = 10,
						type = "header",
						name = L["Bar Style & Layout"],
					},
				},
			},
		})

		local showOptions = {
			alwaysshow = L["Always Show"],
			alwayshide = L["Always Hide"],
			combatshow = L["Show in Combat"],
			combathide = L["Hide in Combat"],
		}

		self.optionobject:AddElement("general", "show", {
			order = 5,
			type = "select",
			name = L["Show/Hide"],
			desc = L["Configure when to Show/Hide the bar."],
			values = showOptions,
			get = function() return self.db.profile.show end,
			set = function(info, value)
				self.db.profile.show = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "alpha", {
			order = 20,
			name = L["Alpha"],
			desc = L["Configure the alpha of the bar."],
			type = "range",
			min = .1,
			max = 1,
			bigStep = 0.1,
			get = function() return self.db.profile.alpha end,
			set = function(info, value)
				self.db.profile.alpha = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "scale", {
			order = 30,
			name = L["Scale"],
			desc = L["Configure the scale of the bar."],
			type = "range",
			min = .1,
			max = 2,
			step = 0.05,
			get = function() return self.db.profile.scale end,
			set = function(info, value)
				self.db.profile.scale = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "fadeout", {
			order = 100,
			name = L["Fade Out"],
			desc = L["Enable the FadeOut mode"],
			type = "toggle",
			width = "full",
			get = function() return self.db.profile.fadeout end,
			set = function(info, value)
				self.db.profile.fadeout = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "fadeoutalpha", {
			order = 101,
			name = L["Fade Out Alpha"],
			desc = L["Enable the FadeOut mode"],
			type = "range",
			min = 0,
			max = 1,
			step = 0.05,
			disabled = function() return not self.db.profile.fadeout end,
			get = function() return self.db.profile.fadeoutalpha end,
			set = function(info, value)
				self.db.profile.fadeoutalpha = value
				self:ApplyConfig()
			end,
		})

		self.optionobject:AddElement("general", "fadeoutdelay", {
			order = 102,
			name = L["Fade Out Delay"],
			desc = L["Enable the FadeOut mode"],
			type = "range",
			min = 0,
			max = 1,
			step = 0.01,
			disabled = function() return not self.db.profile.fadeout end,
			get = function() return self.db.profile.fadeoutdelay end,
			set = function(info, value)
				self.db.profile.fadeoutdelay = value
				self:ApplyConfig()
			end,
		})

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

		-- Bar Width (order 40)
		self.optionobject:AddElement("general", "width", {
			type = "range",
			order = 40,
			name = L["Bar Width"],
			desc = L["Set the width of the bar."] .. " (0 = Full Width)",
			min = 0,
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
		}
		Bartender4:RegisterBarOptions("XPBar", self.options)
	end

	self.options.args = self:IsEnabled() and self.optionobject.table or self.disabledoptions
end
