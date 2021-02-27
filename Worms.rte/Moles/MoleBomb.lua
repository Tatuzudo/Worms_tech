function Create(self)
	self.Timer = Timer();
end

function Update(self)
	if self.Timer:IsPastSimMS(200) then
		self:GibThis()
	end
end