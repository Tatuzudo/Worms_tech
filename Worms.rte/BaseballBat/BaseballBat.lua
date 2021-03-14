function Create(self)
	self.power = 100;
	self.hitSound = CreateSoundContainer("Baseball Bat Hit", "Worms.rte");
	for att in self.Attachables do
		if att.PresetName == "Baseball Cap" then
			self.cap = ToAttachable(att);
		end
	end
end
function Update(self)
	self.Frame = 0;
	if self.RoundInMagCount == 0 then
		self:Reload();
	end
	if self.FiredFrame then
		local hit = false;
		local root = self:GetRootParent();
		local angle = self.RotAngle - self.InheritedRotAngleOffset * self.FlipFactor;
		local launchVector = Vector(self.power * self.FlipFactor, 0):RadRotate(angle);
		local checkPos = root.Pos + Vector(self.Radius * self.FlipFactor, 0):RadRotate(angle);
		for id = 1 , MovableMan:GetMOIDCount() - 1 do
			local mo = MovableMan:GetMOFromID(id);
			if mo and mo.RootID ~= self.RootID and SceneMan:ShortestDistance(checkPos, mo.Pos + mo.Vel * 0.1, SceneMan.SceneWrapsX).Magnitude < self.Radius + mo.Radius * 0.5 then
				mo = ToMOSRotating(mo);
				--Launch MO
				local massFactor = math.max(mo.Mass^0.3, 1);
				mo.Vel = launchVector:SetMagnitude(self.power/massFactor);
				mo.AngularVel = -launchVector.Magnitude * 0.5 * self.FlipFactor;
				if IsActor(mo) then
					mo = ToActor(mo);
					mo.Status = Actor.UNSTABLE;
					mo.Health = mo.Health - launchVector.Magnitude;
				end
				hit = true;
			end
		end
		if hit then
			self.hitSound:Play(self.Pos);
		end
		self.Frame = 1;
		self.StanceOffset = Vector(30, -1);
		self.SharpStanceOffset = Vector(30, -1);
		self.InheritedRotAngleOffset = 0;
	end
	if self:DoneReloading() then
		self.Frame = 1;
		self.StanceOffset = Vector(1, 0);
		self.SharpStanceOffset = Vector(1, 0);
		self.InheritedRotAngleOffset = math.pi - 0.1;
	end
	if self.cap and IsAttachable(self.cap) then
		local parent = self:GetRootParent();
		if parent and IsAHuman(parent) and ToAHuman(parent).Head then
			self.cap.Scale = 1;

			local head = ToAHuman(parent).Head;
			self.cap.Pos = head.Pos + Vector(0, -head:GetSpriteHeight() * 0.5):RadRotate(head.RotAngle);
			self.cap.RotAngle = head.RotAngle;
		else
			self.cap.Scale = 0;
		end
	else
		self.cap = nil;
	end
end