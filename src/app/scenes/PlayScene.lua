FruitItem = import("app.scenes.FruitItem")

local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

function PlayScene:ctor()
	
	
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
	self.matrixLBX = (display.width-FruitItem.getWidth()*self.xCount - (self.xCount - 1)*self.fruitGap)*0.5
	self.matrixLBY = (display.height - FruitItem.getHeight()*self.yCount -(self.yCount-1)*self.fruitGap)*0.5

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
				self:createAndDropFruit(x, y, self.matrix[1].fruitIndex)
			else
				self:createAndDropFruit(x, y)
			end
		end
	end
end

function PlayScene:createAndDropFruit(x, y, fruitIndex )
	local newFruit = FruitItem.new(x,y,fruitIndex)
	local endPosition = self:postionOfFruit(x, y)-- 最终的位置
	local startPosition = cc.p(endPosition.x,endPosition.y+display.height*0.5)
	newFruit:setPosition(startPosition)
	local speed = startPosition.y/(2*display.height)
	newFruit:runAction(cc.MoveTo:create(speed, endPosition))
	self.matrix[(y-1)*self.xCount+x]=newFruit
	self:addChild(newFruit)
end

function PlayScene:postionOfFruit(x, y )
	local px = self.matrixLBX + (FruitItem.getWidth()+self.fruitGap)*(x-1)+FruitItem.getWidth()*0.5
	local py = self.matrixLBY + (FruitItem.getHeight()+self.fruitGap)*(y-1)+FruitItem.getHeight()*0.5
	return cc.p(px,py)
end


function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
