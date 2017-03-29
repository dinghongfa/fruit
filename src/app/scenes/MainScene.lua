
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	-- 1.记载精灵帧
	display.addSpriteFrames("fruit.plist", "fruit.png")
	-- 2.背景图片
	display.newSprite("mainBG.png")
		:pos(display.cx,display.cy)
		:addTo(self)
	local startBtnImages = {
		normal = "#startBtn_N.png",
		pressed = "#startBtn_S.png"
	}
	-- 开始按钮
	cc.ui.UIPushButton.new(startBtnImages, {scale9 = false})
		:onButtonClicked(function(event)
			local playScene = import("app.scenes.PlayScene"):new()
			display.replaceScene(playScene)

		end)
		:align(display.CENTER, display.cx, display.cy-80)
		:addTo(self)	

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
