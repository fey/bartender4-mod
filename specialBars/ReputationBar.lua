--[[ $Id$ ]]
local ReputationBarMod = Bartender4:NewModule("ReputationBar", "AceEvent-3.0")
local Bar = Bartender4.Bar.prototype

local ReputationBar = setmetatable({}, {__index = Bar})

local defaults = { profile = Bartender4:Merge({
	enabled = true,
	showtext = true,
	autohide = true,
}, Bartender4.Bar.defaults) }

function ReputationBarMod:OnInitialize()
	self.db = Bartender4.db:RegisterNamespace("ReputationBar", defaults)
	self:SetEnabledState(self.db.profile.enabled)
end

function ReputationBarMod:OnEnable()
	if not self.bar then
		self.bar = setmetatable(Bartender4.Bar:Create("ReputationBar", self.db.profile, "Reputation Bar"), {__index = ReputationBar})

		local status = CreateFrame("StatusBar", nil, self.bar)
		status:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		status:SetMinMaxValues(0, 1)
		status:SetValue(0)
		status:SetAllPoints(self.bar)
		self.bar.status = status

		local bg = status:CreateTexture(nil, "BACKGROUND")
		bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		bg:SetVertexColor(0.1, 0.1, 0.1, 0.8)
		bg:SetAllPoints(status)
		self.bar.bg = bg

		local text = self.bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		text:SetPoint("CENTER", self.bar, "CENTER", 0, 0)
		self.bar.text = text

		self.bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 24)
		self.bar:SetScript("OnEvent", ReputationBar.OnEvent)
	end

	self.bar:Enable()
	self.bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.bar:RegisterEvent("UPDATE_FACTION")

	self:ApplyConfig()
	self:ToggleOptions()
end

function ReputationBarMod:OnDisable()
	if not self.bar then return end
	self.bar:Disable()
	self:ToggleOptions()
end

function ReputationBarMod:ApplyConfig()
	if not self:IsEnabled() then return end
	self.bar:ApplyConfig(self.db.profile)
end

function ReputationBar:OnEvent()
	self:Update()
end

function ReputationBar:ApplyConfig(config)
	Bar.ApplyConfig(self, config)
	self:PerformLayout()
	self:Update()
end

function ReputationBar:PerformLayout()
	self:SetSize(512, 14)
	self.status:SetAllPoints(self)
	if self.config.showtext then
		self.text:Show()
	else
		self.text:Hide()
	end
end

local standingText = _G.FACTION_STANDING_LABEL
local factionColors = _G.FACTION_BAR_COLORS

function ReputationBar:Update()
	local name, standing, minValue, maxValue, value = GetWatchedFactionInfo()
	if not name then
		if self.config.autohide then
			self:Hide()
		else
			self:Show()
			self.status:SetMinMaxValues(0, 1)
			self.status:SetValue(0)
			if self.config.showtext then
				self.text:SetText("No Watched Reputation")
			end
		end
		return
	end

	self:Show()

	local progress = value - minValue
	local range = maxValue - minValue
	if range < 1 then range = 1 end

	self.status:SetMinMaxValues(0, range)
	self.status:SetValue(progress)

	local color = factionColors and factionColors[standing]
	if color then
		self.status:SetStatusBarColor(color.r, color.g, color.b)
	else
		self.status:SetStatusBarColor(0.0, 0.39, 0.88)
	end

	if self.config.showtext then
		local standingName = standingText and standingText[standing] or ""
		self.text:SetText(("%s: %s %d / %d (%.1f%%)"):format(name, standingName, progress, range, (progress / range) * 100))
	end
end
