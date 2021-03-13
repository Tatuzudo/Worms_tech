function Create(self)
	self.Timer = Timer()
	self.Lifetime = self.Lifetime + 50
end

function Update(self)
	if self.Timer:IsPastSimMS(self.Lifetime - 50) then
		self:GibThis()
	end
end