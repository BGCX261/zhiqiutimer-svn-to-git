-- Author      : Noria
-- Create Date : 7/10/2011 1:51:42 AM

ZQtimer = {}
--GUID MAP
ZQtimer.GUIDList = {}
 --[[
 -- local emptytbl_mt = {

 __index = function(tbl, key)
local new = setmetatable({}, zero_mt)
rawset(tbl, key, new)
return new
end,
}
setmetatable(ZQtimer.GUIDList, emptytbl_mt)
      ]]--
ZQtimer.ArenaEnemyFramearena1 = {}
ZQtimer.ArenaEnemyFramearena2 = {}
ZQtimer.ArenaEnemyFramearena3 = {}
ZQtimer.ArenaEnemyFramearena4 = {}
ZQtimer.ArenaEnemyFramearena5 = {}
--ZQtimer.buffFramesParty# = {}
ZQtimer_DisplayBuff =  {
     "980","172","30108","589"
   }
local MaxAurenaNum = 5
-- arena1~5
-- ZQtimerFrame1~5
--local buffFrames = {}
local debuffFrames = {}

ZQTIMER_Buff_Scale = 1.5
ZQTIMER_FRAME_SIZE = 50
ZQTIMER_FRAME_OFFSET_Y = 2


local BUFFS_PER_ROW = 19
local BUFF_SPACING = 2
local BUFF_TYPE_OFFSET_Y = -7
   --SLASH!!
SLASH_ZQTIMER1="/zqtimer"
SlashCmdList["ZQTIMER"] = function()
   ZQtimerConfig:Show()
end



function ZQtimer:GetParentUnit(self)
    local unitID = self:GetParent():GetAttribute("unit")
    if unitID then
      return unitID
    else
      return "NotIndicate"
    end
  end
  function ZQtimer:Initial_HealthBar(frame)
      frame:SetWidth(ZQTIMER_FRAME_SIZE)
      frame:SetHeight(ZQTIMER_FRAME_SIZE)
      frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
      frame:RegisterEvent("UNIT_HEALTH")
      frame:RegisterEvent("UNIT_MAXHEALTH")
      frame:RegisterEvent("UNIT_NAME_UPDATE")
      frame:SetOrientation("VERTICAL")
      frame:SetMinMaxValues(0, 1)
      frame:SetPoint("BOTTOM",frame:GetParent(),"BOTTOM")
      frame:SetValue(0)
      frame:Show()
      frame:SetStatusBarColor(1, 0, 0, 0.69)
      frame:SetScript("OnEvent",
        function(self, event, unitID)
          if (event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_NAME_UPDATE") and unitID == ZQtimer:GetParentUnit(self) then
            local maxHealth = UnitHealthMax(unitID)
            local Health = UnitHealth(unitID)
            self:SetMinMaxValues(0, maxHealth)
            self:SetValue(maxHealth - Health)
          end
        end)
  end

function ZQtimer:CreateClassIcon(frame,arg1)
    if arg1 then
       frame.ClassIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[arg1]));
     end
end
function ZQtimer:Initial_ZQtimer()
              ZQtimerTargeted:Hide()
              ZQTimerTester:Hide()
  for i=1,5,1 do
              local frame = _G["ZQtimerFrame"..i]
              frame:RegisterForClicks("AnyUp", "AnyDown")          -- 栈溢出
              frame:SetWidth(ZQTIMER_FRAME_SIZE)
              frame:SetHeight(ZQTIMER_FRAME_SIZE)
              _G["ZQtimerFrame"..i.."HealthBar"]:SetWidth(ZQTIMER_FRAME_SIZE)
              _G["ZQtimerFrame"..i.."HealthBar"]:SetHeight(ZQTIMER_FRAME_SIZE)
              ZQtimerTargeted:SetWidth(ZQTIMER_FRAME_SIZE)
              ZQtimerTargeted:SetHeight(ZQTIMER_FRAME_SIZE)

              frame:SetAttribute("unit","arena"..i)
              frame:SetAttribute("type1","target")
              frame:SetAttribute("type2","focus")
              frame:Hide()
          end
ZQtimerBuffsFrame:SetScript("OnEvent",ZQtimer.OnEvent)
ZQtimerTargeted:SetScript("OnEvent",ZQtimer.TargetAnim)

ZQTimerTesterFrame1:Hide()
end
ZQtimer.GUIDListShowAnim = {
    ["arena1"] = function() ZQtimerTargeted:SetPoint("CENTER",  ZQtimerFrame1, "CENTER") end,
    ["arena2"] = function() ZQtimerTargeted:SetPoint("CENTER",  ZQtimerFrame2, "CENTER") end,
    ["arena3"] = function() ZQtimerTargeted:SetPoint("CENTER",  ZQtimerFrame3, "CENTER") end,
    ["arena4"] = function() ZQtimerTargeted:SetPoint("CENTER",  ZQtimerFrame4, "CENTER") end,
    ["arena5"] = function() ZQtimerTargeted:SetPoint("CENTER",  ZQtimerFrame5, "CENTER") end,

}
function ZQtimer:TargetAnim(event,unit)

   if  event == "UNIT_NAME_UPDATE"  then
      --print("UNIT:"..tostring(unit))
      local arenaGUID = UnitGUID(unit)
  --    ChatFrame5:AddMessage(tostring(unit))

      ZQtimer.GUIDList[arenaGUID] = unit
   else if event == "PLAYER_TARGET_CHANGED"  then
         local targetGUID = UnitGUID("target")
         local GUIDtoUNITID = ZQtimer.GUIDList[targetGUID]
         if GUIDtoUNITID then
            if ZQtimer.GUIDListShowAnim[GUIDtoUNITID] then
               ZQtimer.GUIDListShowAnim[GUIDtoUNITID]()
               ZQtimerTargeted:Show()
            else
               ZQtimerTargeted:Hide()
            end
         else
            ZQtimerTargeted:Hide()
         end
      end
   end
end
function ZQtimer:OnLoad(frame)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("UNIT_AURA")
    frame:RegisterEvent("BATTLEFIELDS_SHOW")
    frame:RegisterEvent("BATTLEFIELD_MGR_ENTERED")
    frame:RegisterEvent("UNIT_NAME_UPDATE")
end

function ZQtimer:OnEvent(event, unit)

  if  event == "PLAYER_ENTERING_WORLD" or event == "BATTLEFIELDS_SHOW" or event == "BATTLEFIELD_MGR_ENTERED"  then
    ZQtimer:Initial_ZQtimer()
  else  if event == "UNIT_AURA" or event == "UNIT_NAME_UPDATE"     then
            local MaxPartyNum = MaxAurenaNum


            for i=1,MaxPartyNum,1 do
              local frame = _G["ZQtimerFrame"..i]
              if UnitClass("arena"..i) then
              local _,class = UnitClass("arena"..i)

                frame:Show()

                local anchorBuff = ZQtimer:UpdateBuffs("arena"..i)
                ZQtimer:CreateClassIcon(frame,class)

                ZQtimer:UpdateAnchors(ZQtimer["ArenaEnemyFramearena"..i][1],debuffFrames[1],anchorBuff,i)
              else
                frame:Hide()
              end

            end
--  else if event == "PLAYER_TARGET_CHANGED" then

     end
  end
end
function ZQtimer:UpdateAnchors(firstFrame, secondFrame, anchrTo,id)
  local IconBase
    IconBase =  _G["ZQtimerFrame"..id]

   if firstFrame and firstFrame:IsShown() then
    firstFrame:SetPoint("LEFT",  IconBase,"RIGHT")

    end
end

function ZQtimer:CreateBuffBase(index, frames, name, template)

  local id = string.match(name,"%d")
  local parent = _G["ZQtimerFrame"..id]
 -- ChatFrame5:AddMessage(tostring(id))
    local frame = CreateFrame("Button",name, parent,template)

    frame.unit = "arena"..id
    frame.icon = _G[name.."Icon"]
    frame.cooldown = _G[name.."Cooldown"]
    frame.count = _G[name.."Count"]
    frame.border = _G[name.."Border"]
    frame:SetID(index)


    local relativeTo, relativePoint, offsetX, offsetY
    local point = "TOPLEFT"
    if index ==1 then
        point = "LEFT"
        relativeTo = parent
        relativePoint = "RIGHT"
        offsetX = BUFF_SPACING
        offsetY = 0

    elseif index % BUFFS_PER_ROW == 1 then
        relativeTo = frames[index - BUFFS_PER_ROW]
        relativePoint = "BOTTOMLEFT"
        offsetX = 0
        offsetY = -BUFF_SPACING

    else
        relativeTo = frames[index - 1]
        relativePoint = "TOPRIGHT"
        offsetX = BUFF_SPACING
        offsetY = 0
    end
    frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
    frame:SetScale(ZQTIMER_Buff_Scale)
    frames[index] =frame
    return frame
end


function ZQtimer:CreateDebuff(index,unitID)
 --  ChatFrame5:AddMessage("BIAO JI 1")
 --  ChatFrame5:AddMessage(tostring(index)..":"..unitID)
    return self:CreateBuffBase(
        index,
        ZQtimer["ArenaEnemyFrame"..unitID],
        "ArenaEnemyFrame"..unitID..index,
        "TargetDebuffFrameTemplate"

    )
end

function ZQtimer:UpdateBuffsBase(BuffFunc,frames,method,unitID)
    local index = 1
    local TableIntr = 1

    local icon,count,duration,timeLeft,debuffType,castBy,spellID = BuffFunc(index)

    local anchorBuff
    while castBy == "player" do
      if  ZQtimer:isitIn(spellID,ZQtimer_DisplayBuff) then
            local buff = frames[index] or ZQtimer:CreateDebuff(index, unitID)

            buff:Show()

            if index % BUFFS_PER_ROW ==1 then
                anchorBuff = buff
            end

            buff.icon:SetTexture(icon)

            if count > 1 then
                buff.count:SetText(count)
                buff.count:Show()
            else
                buff.count:Hide()
            end

            if duration then
                if duration > 0  then
                local startTime = GetTime() - (duration - (timeLeft-GetTime()))
                buff.cooldown:SetCooldown(startTime, duration)
                buff.cooldown:Show()
            else
                buff.cooldown:Hide()
            end
            end

            if buff.border then
                local color
                if debuffType then
                    color = DebuffTypeColor[debuffType]
                else
                    color = DebuffTypeColor["none"]
                end
                buff.border:SetVertexColor(color.r, color.g, color.b)
            end
        TableIntr = TableIntr + 1
       end
        index = index + 1
        icon, count ,duration, timeLeft, debuffType, castBy, spellID = BuffFunc(index)
    end

    for i = TableIntr,#frames do
        frames[i]:Hide()
    end
    for i = 1,#frames do

        frames[i]:SetScale(ZQTIMER_Buff_Scale+0.6)
    end
    return anchorBuff
end

function  ZQtimer:UpdateBuffs(unitID)
    return self:UpdateBuffsBase(
    function(index)  
        local icon, count, debuffType,duration, timeLeft,castBy,_,_,spellID =
             select(3, UnitDebuff(unitID,index))
        return icon, count ,duration ,timeLeft, debuffType, castBy, spellID
    end,
    ZQtimer["ArenaEnemyFrame"..unitID],
    "CreateDeBuff",
    unitID
    )
end

function ZQtimer:isitIn(spellID,tb)
   local val = tostring(spellID)
   for key,value in pairs(tb) do
      if val == value then
         return true
      end
   end
   return false
end

function ZQtimer:insert(spellID,tb)
   if not ZQtimer:isitIn(spellID,tb) then
        table.insert(tb,spellID)
   end
end

function ZQtimer:removeFromTb(elm , tb)
   for k , v in pairs(tb) do
      if v == elm then
         print(table.remove(tb,k))
      end
   end
end
