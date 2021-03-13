function Create(self)
	self.Pos.Y = self.Pos.Y -15
	self.Vel.X = 5 - 10*math.random()
	self.Vel.Y = -10 - 10*math.random()
	self.Timer = Timer()
end

function Update(self)
	self.Rot = 0
	self.RotAngle = 0
	self.Vel.X = 0
end

function OnCollideWithMO(self)
	if self.Timer:IsPastSimMS(100) then
		local explosion = CreateMOSRotating("Explosion Donkey", "Worms.rte");
		-- plasma.Team = self.Team;
		explosion.Pos.X = self.Pos.X - 5
		explosion.Pos.Y = self.Pos.Y + 60
		MovableMan:AddParticle(explosion);
		self.Vel.Y = -10
		self.Timer:Reset()
	end
end

function OnCollideWithTerrain(self)
	if self.Timer:IsPastSimMS(100) then
		local explosion = CreateMOSRotating("Explosion Donkey", "Worms.rte");
		-- plasma.Team = self.Team;
		explosion.Pos.X = self.Pos.X - 5
		explosion.Pos.Y = self.Pos.Y + 60
		MovableMan:AddParticle(explosion);
		self.Vel.Y = -10
		self.Timer:Reset()
	end
end