-- Author      : Noria
-- Create Date : 7/10/2011 1:51:42 AM

TargetTextBuffs = {}
TargetTextBuffs.ArenaEnemyFramearena1 = {}
TargetTextBuffs.ArenaEnemyFramearena2 = {}
TargetTextBuffs.ArenaEnemyFramearena3 = {}
TargetTextBuffs.ArenaEnemyFramearena4 = {}
TargetTextBuffs.ArenaEnemyFramearena5 = {}
--TargetTextBuffs.buffFramesParty# = {}

local MaxAurenaNum = 5
-- arena1~5
-- TargetTextFrame1~5
--local buffFrames = {}
local debuffFrames = {}


ZQTIMER_FRAME_SIZE = 50
ZQTIMER_FRAME_OFFSET_Y = 2


local BUFFS_PER_ROW = 9
local BUFF_SPACING = 2
local BUFF_TYPE_OFFSET_Y = -7



function TargetTextBuffs:CreateClassIcon(frame,arg1)
    if arg1 then
   --     local wtf=frame:CreateTexture("fucku",nil,7);
    --    wtf:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES");
       frame.ClassIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[arg1]));
   --     wtf:SetAllPoints()
     end
end
function TargetTextBuffs:Initial_ZQtimer()
  for i=1,5,1 do
              local frame = _G["TargetTextFrame"..i]
              frame:RegisterForClicks("AnyUp", "AnyDown")
              frame:SetAttribute("unit","arena"..i)
              frame:SetAttribute("type1","target")
              frame:SetAttribute("type2","focus")

          end


end


function TargetTextBuffs:OnLoad(frame)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("UNIT_AURA")
end

function TargetTextBuffs:OnEvent(event, unit)
  if event == "PLAYER_ENTERING_WORLD" then
    TargetTextBuffs:Initial_ZQtimer()
  end
         local MaxPartyNum = MaxAurenaNum


            for i=1,MaxPartyNum,1 do
              local frame = _G["TargetTextFrame"..i]
              if UnitClass("arena"..i) then
              local _,class = UnitClass("arena"..i)
         --       frame.unit = "arena"..i
                frame:Show()

                local anchorBuff = self:UpdateBuffs("arena"..i)
                TargetTextBuffs:CreateClassIcon(frame,class)

                self:UpdateAnchors(TargetTextBuffs["ArenaEnemyFramearena"..i][1],debuffFrames[1],anchorBuff,i)
              else
                frame:Hide()
              end

            end


end

function TargetTextBuffs:UpdateAnchors(firstFrame, secondFrame, anchrTo,id)
  local IconBase
    IconBase =  _G["TargetTextFrame"..id]

   if firstFrame and firstFrame:IsShown() then
    firstFrame:SetPoint("LEFT",  IconBase,"RIGHT")
        if secondFrame and secondFrame:IsShown() then
            secondFrame:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", 0 , BUFF_TYPE_OFFSET_Y)
        end
    elseif secondFrame and secondFrame:IsShown() then
        secondFrame:SetPoint("TOPLEFT", IconBase)
    end
end

function TargetTextBuffs:CreateBuffBase(index, frames, name, template)

  local id = string.match(name,"%d")
  local parent = _G["TargetTextFrame"..id]
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
    frame:SetScale(1.5)
    frames[index] =frame
    return frame
end

--[[function TargetTextBuffs:CreateBuff(index,unitID)
    return self:CreateBuffBase(
        index,
        TargetTextBuffs["buffFrames"..unitID],
        "TargetTextBuff"..unitID..index,
        "TargetDebuffFrameTemplate"

    )
end               ]]--

function TargetTextBuffs:CreateDebuff(index,unitID)
 --  ChatFrame5:AddMessage("BIAO JI 1")
 --  ChatFrame5:AddMessage(tostring(index)..":"..unitID)
    return self:CreateBuffBase(
        index,
        TargetTextBuffs["ArenaEnemyFrame"..unitID],
        "ArenaEnemyFrame"..unitID..index,
        "TargetDebuffFrameTemplate"

    )
end

function TargetTextBuffs:UpdateBuffsBase(BuffFunc,frames,method,unitID)
    local index = 1
    local icon,count,duration,timeLeft,debuffType,castBy = BuffFunc(index)

    local anchorBuff

--    while castBy == "player" do
    while castBy == "player" do
        local buff = frames[index] or TargetTextBuffs:CreateDebuff(index, unitID)

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
 --       print("110:"..duration)
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

        index = index + 1
        icon, count ,duration, timeLeft, debuffType, castBy = BuffFunc(index)
    end

    for i = index,#frames do 
        frames[i]:Hide()
    end

    return anchorBuff
end

function TargetTextBuffs:UpdateBuffs(unitID)
    return self:UpdateBuffsBase(
    function(index)  
        local icon, count, debuffType,duration, timeLeft,castBy =
             select(3, UnitDebuff(unitID,index))
        return icon, count ,duration ,timeLeft,debuffType,castBy
    end,
    TargetTextBuffs["ArenaEnemyFrame"..unitID],
    "CreateDeBuff",
    unitID
    )
end

--[[function TargetTextBuffs:UpdateDebuffs(unitID)
    return self:UpdateBuffsBase(
    function(index)  
        local icon, count,debuffType, duration, timeLeft,castBy =
             select(3, UnitDebuff(unitID,index))
        return icon, count ,duration ,timeLeft,debuffType,castBy
    end,
    debuffFrames,
    "CreateDebuff"
    )
end            ]]--