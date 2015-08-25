---
-- Created by IntelliJ IDEA.
-- User: Noria
-- Date: 11-11-14
-- Time: 下午8:01
-- To change this template use File | Settings | File Templates.
local test = CreateFrame("Button", "wrs",UIParent,"SecureUnitButtonTemplate")
local _,arg1 = UnitClass("Player")
test:RegisterForClicks("AnyUp", "AnyDown")
test:SetAttribute("unit","player")
test:SetAttribute("type1","target")
test:SetAttribute("type2","focus")
test:SetHeight(70)
test:SetWidth(70)
test:SetPoint("CENTER", UIParent, "CENTER", 100, 0)
test:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",

      tile = true,

      tileSize = 32,

      edgeSize = 10,

      insets = {
         left = 11,
         right = 12,
         top = 12,
         bottom = 11
      }
})
local wtf=test:CreateTexture("fucku",nil,7);
wtf:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES");
wtf:SetTexCoord(unpack(CLASS_ICON_TCOORDS[arg1]));
wtf:SetAllPoints()



test:SetMovable(1)
test:EnableMouse()
test:SetScript("OnMouseDown", function() test:StartMoving() end)
test:SetScript("OnMouseUp", function() test:StopMovingOrSizing() end)
