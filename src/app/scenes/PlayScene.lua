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
	self.scoreStart = 5 -- 水果基分
	self.scoreStep = 10 -- 加成分数
	self.activeScore = 0 -- 当前高亮的水果得分
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


	self.activeScoreLabel = display.newTTFLabel({text = "",size = 30})
		:pos(display.width*0.5,120)
		:addTo(self)

	self.activeScoreLabel:setColor(display.COLOR_WHITE)
end

function PlayScene:initMartix( )
	self.matrix = {}-- 创建空的矩阵
	self.actives = {} -- 高亮水果
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
	--绑定触摸事件
	newFruit:setTouchEnabled(true)
	newFruit:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
		if event.name=="ended" then
			if newFruit.isActive then
				self:removeActiveFruits()
				self:dropFruits()
			else
				self:inactive()
				self:activeNeighbor(newFruit)
				self:showActivesScore()
			end
		end

		if event.name == "began" then
			return true
		end
	end)
end 
function PlayScene:removeActiveFruits( )
	local fruitScore = self.scoreStart -- 基分
	for _,fruit in pairs(self.actives) do
		if fruit then
			self.matrix[(fruit.y-1)*self.xCount+fruit.x]=nil
			fruitScore = fruitScore + self.scoreStep
			fruit:removeFromParent()
		end
	end
	-- 清空高亮数组
	self.actives = {}
	self.curSorce = self.curSorce + self.activeScore
	self.highScoreLabel:setString(tostring(self.curSorce))
	self.activeScoreLabel:setString("")
	self.activeScore = 0
end


function PlayScene:activeNeighbor(fruit)
	-- 高亮fruit
	if false == fruit.isActive then
		fruit:setActive(true)
		table.insert(self.actives,fruit)
	end
	--检查fruit 左边的水果
	if (fruit.x-1)>=1 then
		local leftNeighbor = self.matrix[(fruit.y-1)*self.xCount + fruit.x-1]
		if (leftNeighbor.isActive==false)and(leftNeighbor.fruitIndex == fruit.fruitIndex) then
			leftNeighbor:setActive(true)
			table.insert(self.actives,leftNeighbor)
			self:activeNeighbor(leftNeighbor)
		end
	end

		--检查fruit 右边的水果
	if (fruit.x+1)<=self.xCount then
		local rightNeighbor = self.matrix[(fruit.y-1)*self.xCount + fruit.x+1]
		if (rightNeighbor.isActive==false)and(rightNeighbor.fruitIndex == fruit.fruitIndex) then
			rightNeighbor:setActive(true)
			table.insert(self.actives,rightNeighbor)
			self:activeNeighbor(rightNeighbor)
		end
	end
		--检查fruit 下边的水果
	if (fruit.y-1)>=1 then
		local downNeighbor = self.matrix[(fruit.y-2)*self.xCount + fruit.x]
		if (downNeighbor.isActive==false)and(downNeighbor.fruitIndex == fruit.fruitIndex) then
			downNeighbor:setActive(true)
			table.insert(self.actives,downNeighbor)
			self:activeNeighbor(downNeighbor)
		end
	end
		--检查fruit 上边的水果
	if (fruit.y+1)<=self.yCount then
		local upNeighbor = self.matrix[(fruit.y)*self.xCount + fruit.x]
		if (upNeighbor.isActive==false)and(upNeighbor.fruitIndex == fruit.fruitIndex) then
			upNeighbor:setActive(true)
			table.insert(self.actives,upNeighbor)
			self:activeNeighbor(upNeighbor)
		end
	end
end

function PlayScene:showActivesScore( )
	-- 只有一个高亮，取消高亮并返回
	if 1==#self.actives then
		self:inactive()
		self.activeScoreLabel:setString("")
		self.activeScore = 0
		return
	end

	self.activeScore = (self.scoreStart*2+self.scoreStep*(#self.actives-1))*#self.actives/2
	self.activeScoreLabel:setString(string.format("%d连消，得分%d",#self.actives,self.activeScore))
end

function PlayScene:inactive( )
	for _,fruit in pairs(self.actives) do
		if fruit then
			fruit:setActive(false)
		end
	end
	self.actives = {}
end

function PlayScene:postionOfFruit(x, y )
	local px = self.matrixLBX + (FruitItem.getWidth()+self.fruitGap)*(x-1)+FruitItem.getWidth()*0.5
	local py = self.matrixLBY + (FruitItem.getHeight()+self.fruitGap)*(y-1)+FruitItem.getHeight()*0.5
	return cc.p(px,py)
end


function PlayScene:dropFruits() 
	local emptyInfo = {}
	--1,掉落已存在的水果
	-- 一列列的处理
	for x=1,self.xCount do
		local removeFruits = 0 -- 移出的水果数 （在一列上）
		local newY = 0 -- 新的掉落的y 坐标
		for y=1,self.yCount do
			local temp = self.matrix[(y-1)*self.xCount+x]
			if temp==nil then
				-- 水果已被移出
				removeFruits = removeFruits+1
			else
				--如果水果下面有空缺 ，则往下移动
				if removeFruits>0 then
					newY = y - removeFruits  
					self.matrix[(newY-1)*self.xCount +x] = temp
					temp.y = newY
					self.matrix[(y-1)*self.xCount+x]= nil
					local endPosition = self:postionOfFruit(x, newY)
					local speed = (temp:getPositionY()-endPosition.y)/display.height
					temp:stopAllActions()
					temp:runAction(cc.MoveTo:create(speed, endPosition))
				end
			end
		end
		emptyInfo[x]=removeFruits--记录本行空缺处
	end
	-- 2，掉落新的水果并补齐空缺
	for x=1,self.xCount do
		for y=self.yCount-emptyInfo[x]+1,self.yCount do
			self:createAndDropFruit(x, y)
		end
	end

end

function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
