FruitItem = import("app.scenes.FruitItem")

local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

function PlayScene:ctor()
	
	math.newrandomseed() -- 随机种子
	--init value
	self.highSorce = 0
	self.stage = 1
	self.target =123
	self.curSorce = 0
	self.xCount = 8 -- 水平方向水果数
	self.yCount = 8 -- 垂直方向水果数
	self.fruitGap = 0 -- 水果间距
	self:initUI()

	-- 棋盘左下角的坐标
	self.matrixLBX = (display.width-Fruit.getWidth()*self.xCount - (self.xCount - 1)*self.fruitGap)*0.5
	self.matrixLBY = (display.height - Fruit.getHeight()*self.yCount -(self.yCount-1)*self.fruitGap)*0.5

	self:addNodeEventListener(cc.NODE_EVENT,function ( event )
		if event.name == "enterTransitionFinish" then
			self:initMartix() -- 初始化矩阵
		end
	end)


end 

function PlayScene:initUI()
	display.newSprite("#high_score.png")
		:align(display.LEFT_CENTER,display.left+15,display.top-30)
		:addTo(self)

	display.newSprite("#highscore_part.png")
		:align(display.LEFT_CENTER, display.cx+10, display.top-26)
		:addTo(self)

	self.highScoreLabel = cc.ui.UILabel.new({UILabelType = 1,text = tostring(self.highSorce),font = "font/earth38.fnt"})
		:align(display.CENTER, display.cx+105, display.top-20)
		:addTo(self)

end

function PlayScene:initMartix( )
	self.matrix = {}-- 创建空的矩阵
	for y=1,self.yCount do
		for x=1,self.xCount do
			if 1==y and 2==x then
				--确保有可能消除的水果	
			else
					
			end
		end
	end
end


function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
