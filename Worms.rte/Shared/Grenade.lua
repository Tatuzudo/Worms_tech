function Create(self)
	self.fuzeDelayS = 3;
	self.fuzeDelayMax = 5;
	self.rotation = 0;
end
function Update(self)
	local parent = self:GetRootParent();
	if parent and IsActor(parent) then
		parent = ToActor(parent);
	else
		self.AngularVel = 0;
		self.RotAngle = self.RotAngle - self.Vel.Magnitude * TimerMan.DeltaTimeSecs * self.FlipFactor;
		if math.abs(self.RotAngle) > math.pi then
			self.RotAngle = self.RotAngle > 0 and self.RotAngle - math.pi * 2 or self.RotAngle + math.pi * 2;
		end
	end
	if self.fuze then
		if self.fuze:IsPastSimTimeLimit() then
			self:GibThis();
		else
			PrimitiveMan:DrawTextPrimitive(self.Pos + Vector(-self.Radius, -self.Diameter), tostring(math.ceil(self.fuzeDelayS - self.fuze.ElapsedSimTimeS)), false, 1);
		end
	elseif self:IsActivated() then
		self.fuze = Timer();
		self.fuze:SetSimTimeLimitS(self.fuzeDelayS);
	else
		local parent = self:GetRootParent();
		if parent and IsActor(parent) then
			parent = ToActor(parent);
			local controller = parent:GetController();
			if controller:IsState(Controller.WEAPON_RELOAD) then
				self.fuzeDelayS = (self.fuzeDelayS % self.fuzeDelayMax) + 1;
				local screen = ActivityMan:GetActivity():ScreenOfPlayer(controller.Player);
				if screen ~= -1 then
					FrameMan:SetScreenText("Fuze: " .. self.fuzeDelayS .. " seconds", screen, 0, 1000, false);
				end
			end
		end
	end
end