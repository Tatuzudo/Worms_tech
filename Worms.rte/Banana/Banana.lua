function Create(self)
	self.Pos.Y = self.Pos.Y -15
	self.Vel.X = 5 - 10*math.random()
	self.Vel.Y = -10 - 10*math.random()
end

-- function OnCollideWithMO(self)
	-- self:GibThis()
-- end

-- function OnCollideWithTerrain(self)
	-- self:GibThis()
-- end