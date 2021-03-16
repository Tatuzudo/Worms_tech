function Create(self)
	self.Timer = Timer()
	self.explodeTime = 20000
	self.HFlipped = false
	self.Explode = false
	if self.HFlipped == true then
		self.Vel.X = -16
		self.Imp = -0.5
	else
		self.Vel.X = 16
		self.Imp = 0.5
	end
end

function Update(self)
	if self.Vel.X > 0 then
		self.HFlipped = false
	else
		self.HFlipped = true
	end
	
	if self.HFlipped == true then
		self.RotAngle = math.atan2(self.Vel.Y, -self.Vel.X)
	else
		self.RotAngle = -math.atan2(self.Vel.Y, self.Vel.X)
	end
	
	SceneMan:RevealUnseen(self.Pos.X,self.Pos.Y,self.Team)
	self:AddImpulseForce(Vector(self.Imp,0), Vector(0,0))
	self.Imp = self.Imp*0.995
	if math.abs(self.AngularVel) > 1 then
		self.AngularVel = self.AngularVel/2
	end
	
	if self.Timer:IsPastSimMS(self.explodeTime) then
		self:GibThis()
	end
	
	self.vec = Vector(self.Vel.X,self.Vel.Y):SetMagnitude(30)
	self.orL = self.Pos + Vector(self.Vel.X,self.Vel.Y):SetMagnitude(5):DegRotate(-90)
	self.orR = self.Pos + Vector(self.Vel.X,self.Vel.Y):SetMagnitude(5):DegRotate(90)
	self.ray = SceneMan:CastObstacleRay(self.Pos, self.vec, Vector(0,0), Vector(0,0), 0, self.Team, 0, 2)
	self.rayL = SceneMan:CastObstacleRay(self.orL, self.vec, Vector(0,0), Vector(0,0), 0, self.Team, 0, 2)
	self.rayR = SceneMan:CastObstacleRay(self.orR, self.vec, Vector(0,0), Vector(0,0), 0, self.Team, 0, 2)
	if (self.ray > 0 or self.rayL > 0 or self.rayR > 0) and self.Explode == false then
		self:EraseFromTerrain()
		self.GlobalAccScalar = 0.2
		self:EnableEmission(true)
		if self.Vel.Y > 5 then
			self.Vel = self.Vel/1.5
		end
		self.DTimer = Timer()
	else
		self.GlobalAccScalar = 1
		self:EnableEmission(false)
		if self.DTimer and self.DTimer:IsPastSimMS(100) then
			self.Explode = true
		end
	end
end