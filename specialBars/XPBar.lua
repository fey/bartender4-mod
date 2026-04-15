--[[ $Id$ ]]
local XPBarMod = Bartender4:NewModule("XPBar", "AceEvent-3.0")
local Bar = Bartender4.Bar.prototype

local XPBar = setmetatable({}, {__index = Bar})

local defaults = { profile = Bartender4:Merge({
	enabled = true,
	showtext = true,
	showrested = true,
	width = 512,
	height = 14,
	texture = "Interface\\TARGETINGFRAME\\UI-StatusBar",
}, Bartender4.Bar.defaults) }

function XPBarMod:OnInitialize()
	self.db = Bartender4.db:RegisterNamespace("XPBar", defaults)
	self:SetEnabledState(self.db.profile.enabled)
end

function XPBarMod:OnEnable()
	if not self.bar then
		self.bar = setmetatable(Bartender4.Bar:Create("XPBar", self.db.profile, "XP Bar"), {__index = XPBar})

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

		local textFrame = CreateFrame("Frame", nil, self.bar)
		textFrame:SetAllPoints(self.bar)
		textFrame:SetFrameLevel(self.bar.status:GetFrameLevel() + 2)

		local text = textFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		text:SetPoint("CENTER", textFrame, "CENTER", 0, 0)
		self.bar.text = text

		self.bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 8)
		self.bar:SetScript("OnEvent", XPBar.OnEvent)
	end

	self.bar:Enable()
	self.bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.bar:RegisterEvent("PLAYER_XP_UPDATE")
	self.bar:RegisterEvent("PLAYER_LEVEL_UP")
	self.bar:RegisterEvent("UPDATE_EXHAUSTION")

	self:ApplyConfig()
	self:ToggleOptions()
end

function XPBarMod:OnDisable()
	if not self.bar then return end
	self.bar:Disable()
	self:ToggleOptions()
end

function XPBarMod:ApplyConfig()
	if not self:IsEnabled() then return end
	self.bar:ApplyConfig(self.db.profile)
end

function XPBar:OnEvent()
	self:Update()
end

function XPBar:ApplyConfig(config)
	Bar.ApplyConfig(self, config)
	self:PerformLayout()
	self:Update()
end

function XPBar:PerformLayout()
	local width = self.config.width or 512
	local height = self.config.height or 14
	local texture = self.config.texture or "Interface\\TARGETINGFRAME\\UI-StatusBar"
	self:SetSize(width, height)
	self.status:SetAllPoints(self)
	-- Apply texture
	self.status:SetStatusBarTexture(texture)
	self.bg:SetTexture(texture)
	if self.config.showtext then
		self.text:Show()
	else
		self.text:Hide()
	end
end

function XPBar:Update()
	local currentXP = UnitXP("player")
	local maxXP = UnitXPMax("player")

	if not maxXP or maxXP == 0 then
		self.status:SetMinMaxValues(0, 1)
		self.status:SetValue(0)
		if self.config.showtext then
			self.text:SetText("")
		end
		return
	end

	self.status:SetStatusBarColor(0.58, 0.0, 0.55)
	self.status:SetMinMaxValues(0, maxXP)
	self.status:SetValue(currentXP)

	if self.config.showtext then
		local text = ("%d / %d (%.1f%%)"):format(currentXP, maxXP, (currentXP / maxXP) * 100)
		local rested = GetXPExhaustion() or 0
		if self.config.showrested and rested > 0 then
			text = text .. (" +%d"):format(rested)
		end
		self.text:SetText(text)
	end
end

function XPBar:GetBarWidth()
	return self.config.width
end

function XPBar:SetBarWidth(width)
	self.config.width = width
	self:PerformLayout()
end

function XPBar:GetBarHeight()
	return self.config.height
end

function XPBar:SetBarHeight(height)
	self.config.height = height
	self:PerformLayout()
end

function XPBar:GetBarTexture()
	return self.config.texture
end

function XPBar:SetBarTexture(texture)
	self.config.texture = texture
	self:PerformLayout()
end
