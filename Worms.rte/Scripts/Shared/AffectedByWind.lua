function Update(self)
	if Wind then
		self.Vel.X = self.Vel.X + Wind/math.max(self.Mass^0.5, 1);
	end
end