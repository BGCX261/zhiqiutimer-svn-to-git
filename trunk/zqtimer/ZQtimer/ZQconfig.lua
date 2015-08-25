---
-- Created by IntelliJ IDEA.
-- User: Noria
-- Date: 11-11-22
-- Time: 下午12:14
-- To change this template use File | Settings | File Templates.
--
local ClassIconAnchors = _G["ZQtimerFrame1"]
                                    --先全局吧
ZQTimerTester = CreateFrame("Button","ZQTimerTesterFrame1")
ZQTimerTester:SetPoint("LEFT",ZQtimerFrame1,"RIGHT",0,0)
ZQTimerTester:SetHeight(17)
ZQTimerTester:SetWidth(17)
ZQTimerTester:SetBackdrop({

      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
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

local debuff = ZQTimerTester:CreateTexture("zqt232",nil,7)
debuff:SetTexture("Interface\\Icons\\Ability_BackStab");
debuff:SetAllPoints()
--ZQTimerTester:SetScale(ZQTIMER_Buff_Scale)
ZQTimerTester:SetScale(ZQTIMER_Buff_Scale+0.6)
ZQTimerTester:Hide()


function ZQtimer:ClassFrameUpdateSize()
      for i=1,5,1 do
          local frame = _G["ZQtimerFrame"..i]
          _G["ZQtimerFrame"..i.."HealthBar"]:SetWidth(ZQTIMER_FRAME_SIZE)
          _G["ZQtimerFrame"..i.."HealthBar"]:SetHeight(ZQTIMER_FRAME_SIZE)
          frame:SetWidth(ZQTIMER_FRAME_SIZE)
          frame:SetHeight(ZQTIMER_FRAME_SIZE)
          if i==1 then
          else
            local offset_Y = ZQTIMER_FRAME_OFFSET_Y + (ZQTIMER_FRAME_SIZE + ZQTIMER_FRAME_OFFSET_Y)*(i-2)
            frame:SetPoint("TOP",ZQtimerFrame1,"BOTTOM",0 , -offset_Y)
          end

      end
      ZQtimerTargeted:SetWidth(ZQTIMER_FRAME_SIZE)
      ZQtimerTargeted:SetHeight(ZQTIMER_FRAME_SIZE)
end


function ZQtimer:Tester()
   ZQtimerBuffsFrame:SetScript("OnEvent",function()  end)
   ZQtimerTargeted:SetScript("OnEvent",function()  end)
   ZQtimerTargeted:Show()
   ZQtimerTargeted:SetPoint("CENTER",  ZQtimerFrame1, "CENTER")

   local _,class = UnitClass("player")
   for i=1,5,1 do
      local frame = _G["ZQtimerFrame"..i]
      frame:RegisterForClicks("AnyUp", "AnyDown")
      frame:SetAttribute("unit","player")
      frame:SetAttribute("type1","target")
      frame:SetAttribute("type2","focus")
      ZQtimer:CreateClassIcon(frame,class)
      _G["ZQtimerFrame"..i.."HealthBar"]:SetWidth(ZQTIMER_FRAME_SIZE)
      _G["ZQtimerFrame"..i.."HealthBar"]:SetHeight(ZQTIMER_FRAME_SIZE)
      ZQtimerTargeted:SetWidth(ZQTIMER_FRAME_SIZE)
      ZQtimerTargeted:SetHeight(ZQTIMER_FRAME_SIZE)
      _G["ZQtimerFrame"..i.."HealthBar"]:SetMinMaxValues(0, 10000)
      _G["ZQtimerFrame"..i.."HealthBar"]:SetValue(4000)
      frame:Show()
   end
      ZQTimerTesterFrame1:SetScale(ZQTIMER_Buff_Scale)
      ZQTimerTesterFrame1:Show()

end

function ZQtimer:GetSpellIdByName(name)
   local link = GetSpellLink(name)
   if link then
   local test = string.match(link,"^.+Hspell:(%d+)")
   local b = tonumber(test)
    return b
   else
     return nil
   end
end
function ZQtimer:ZQtimerAuraEditOnEnterPressed()
 -- local unk ="Interface\\InventoryItems\\WoWUnknownItem01.blp"
    local spellId
    local spellName = ZQtimerAuraEdit:GetText()
    if spellName then
       spellId =  tostring(ZQtimer:GetSpellIdByName(spellName))
          if not (spellId == "nil") then
             ZQtimer:insert(spellId,ZQtimer_DisplayBuff)
             MacroIconTest_UpdateIcons(1)
             local max = #ZQtimer_DisplayBuff
             if max < 5 then
               max = 5
             end
			 MacroIconTest_HSlider:SetMinMaxValues(1, max)
		     MacroIconTest_HSlider:SetValueStep(1.0)
			 MacroIconTest_HSlider:SetValue(1)
          end
    end

end

function ZQtimer:ZQtimerAuraEditOnTextChange()
    local unk ="Interface\\InventoryItems\\WoWUnknownItem01.blp"
    local spellId
    local spellName = ZQtimerAuraEdit:GetText()
    if spellName then
      spellId =  ZQtimer:GetSpellIdByName(spellName)
    else
      ZQtimerAuraCfgIcon:SetTexture(unk)
    end
    if spellId then
      local _,_,path = GetSpellInfo(spellId)
      ZQtimerAuraCfgIcon:SetTexture(path)
    else
      ZQtimerAuraCfgIcon:SetTexture(unk)
    end
end

function MacroIconTest_UpdateIcons(startIcon)
  local name = "MacroIconTestIcon"

  for i=1,5 do
            local text = _G["MacroIconTestIcon"..i.."SpellName"]
            local button = getglobal(name .. i.."Icon")
            local delBtn = _G["MacroIconTestIcon"..i.."DelBtn"]
    local spellID = tonumber(ZQtimer_DisplayBuff[startIcon + (i - 1)])
    if spellID then
    local spellName,_,path = GetSpellInfo(spellID)
                if path then

              text:SetText(spellName)
              button:SetTexture(path)
              delBtn:SetBackdrop({
                bgFile="Interface\\LootFrame\\LootPanel-Icon" ,
        })
              delBtn:SetScript("OnClick",function()
                      ZQtimer:removeFromTb(tostring(spellID),ZQtimer_DisplayBuff)
               MacroIconTest_UpdateIcons(1)
               local max = #ZQtimer_DisplayBuff
               if max < 5 then
                 max = 5
               end
               MacroIconTest_HSlider:SetMinMaxValues(1, max)
               MacroIconTest_HSlider:SetValueStep(1.0)
               MacroIconTest_HSlider:SetValue(1)
             end)

            end
          else
            text:SetText(nil)
            button:SetTexture(nil)
            delBtn:SetBackdrop(nil)
      end
  end
end

function MacroIconTest_OnMouseWheel(self, delta)
  local current = MacroIconTest_HSlider:GetValue()

  if (delta < 0) and (current < #ZQtimer_DisplayBuff) then
    MacroIconTest_HSlider:SetValue(current + 1)
  elseif (delta > 0) and (current > 1) then
    MacroIconTest_HSlider:SetValue(current - 1)
  end
end

