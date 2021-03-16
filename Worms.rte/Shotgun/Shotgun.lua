function Create(self)
	self.range = (FrameMan.PlayerScreenWidth + FrameMan.PlayerScreenHeight) * 0.5;
	self.fireDelay = 1000;
	self.cockSound = CreateSoundContainer("Worms Shotgun Cock Sound", "Worms.rte");
	--The following timer resets the fire phase when the gun is put inside an inventory
	self.inventorySwapTimer = Timer();
	self.inventorySwapTimer:SetSimTimeLimitMS(math.ceil(TimerMan.DeltaTimeMS));
	self.disableControls = {Controller.WEAPON_CHANGE_NEXT, Controller.WEAPON_CHANGE_PREV, Controller.WEAPON_FIRE,
							Controller.MOVE_LEFT, Controller.MOVE_RIGHT, 
							Controller.BODY_JUMP, Controller.BODY_JUMPSTART, Controller.BODY_CROUCH};
end
function Update(self)
	if self.fireTimer then
		local actor = self:GetRootParent();
		if actor and IsActor(actor) then
			local controller = ToActor(actor):GetController();
			--Disable most controls while firing
			for _, state in pairs(self.disableControls) do
				controller:SetState(state, false);
			end
			controller:SetState(Controller.AIM_SHARP, self.aiming);
			controller:SetState(Controller.BODY_CROUCH, self.crouching);
		end
		if not self.cooldown then 
			if self.fireTimer:IsPastSimMS(self.fireDelay) and not self.inventorySwapTimer:IsPastSimTimeLimit() then
				--Fire the shot
				self:Activate();
				self.cooldown = Timer();
			else
				self:Deactivate();
			end
		elseif self.cooldown:IsPastSimMS(self.fireDelay * 0.5) then
			self.fireTimer = nil;
			self.cooldown = nil;
		else
			self:Deactivate();
		end
	elseif self.RoundInMagCount == 0 then
		self:Reload();
	elseif self:IsActivated() then
		self:Deactivate();
		self.fireTimer = Timer();
		self.cockSound:Play(self.Pos);

		local actor = self:GetRootParent();
		if actor and IsActor(actor) then
			local controller = ToActor(actor):GetController();
			self.aiming = controller:IsState(Controller.AIM_SHARP);
			self.crouching = controller:IsState(Controller.BODY_CROUCH);
		end
	end
	if self.FiredFrame then
		local parent = self:GetRootParent();
		if IsActor(parent) then
			parent = ToActor(parent);
		end
		local hitPos = Vector();
		local trace = Vector(self.range * self.FlipFactor, 0):RadRotate(self.RotAngle);
		local ray = SceneMan:CastObstacleRay(self.MuzzlePos, trace, hitPos, Vector(), parent.ID, -2, rte.airID, 2);
		if ray >= 0 then
			--To-do: add terrain erasing particle
			local glow = CreateMOPixel("Glow Explosion Huge");
			glow.Pos = hitPos;
			MovableMan:AddParticle(glow);

			local id = SceneMan:GetMOIDPixel(hitPos.X, hitPos.Y);
			if id ~= rte.NoMOID and id ~= parent.ID then
				local mo = ToMOSRotating(MovableMan:GetMOFromID(id));
				local rootMO = mo:GetRootParent();
				rootMO.Vel = rootMO.Vel * 0.5 + Vector(50/math.sqrt(math.abs(rootMO.Mass) + 1) * self.FlipFactor, 0):RadRotate(self.RotAngle);
				if IsActor(rootMO) then
					rootMO = ToActor(rootMO);
					rootMO.Health = rootMO.Health - 25;
					rootMO.Status = Actor.UNSTABLE;
				end
			end
		end
	end
	self.inventorySwapTimer:Reset();
end