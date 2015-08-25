-- Author      : Noria
-- Create Date : 11/21/2011 4:56:42 PM
--print(tostring(ZQTIMER_FRAME_SIZE)..":"..tostring(ZQTIMER_Buff_Scale))



function ZqUnitBuffResizeSlider_OnButtonUp(self, button)
  if button == "LeftButton"   then
      ZQtimer:Initial_ZQtimer()
      ZQtimer:Tester()
  end
end

function MacroIconTest_HSlider_OnLoad(self)
					local max = #ZQtimer_DisplayBuff
                    if max < 5 then
                     max = 5
                    end
					self:SetMinMaxValues(1, max - 4)
					self:SetValueStep(1.0)
                    self:SetValue(1)

end
function ZqUnitClassResizeSlider_OnValueChanged()
--        print("ZqUnitClassResizeSlider_OnValueChanged")
    ZQTIMER_FRAME_SIZE = ZqUnitClassResizeSlider:GetValue()
      ZQtimer:ClassFrameUpdateSize()

end

function ZqUnitBuffResizeSlider_OnValueChanged()
--    print("ZqUnitBuffResizeSlider_OnValueChanged")
    ZQTIMER_Buff_Scale = ZqUnitBuffResizeSlider:GetValue()
     --   ZQTimerTester:SetScale(ZQTIMER_Buff_Scale)
end

function ZQtimerButtonClose_OnClick()
    ZQtimerConfig:Hide()
    ZQtimer:Initial_ZQtimer()
end


function ZQtimerButtonTest_OnClick()
     ZQtimer:Initial_ZQtimer()
     ZQtimer:Tester()
end


