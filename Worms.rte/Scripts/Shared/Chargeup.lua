	function Create(self)
	self.minFireVel = 10;
	self.maxFireVel = 50;
	
	self.chargeDelay = 1500;
	self.charge = 0;

	self.chargeTimer = Timer();
	self.chargeTimer:SetSimTimeLimitMS(self.chargeDelay);
	--The following timer prevents a glitch where you can fire twice by putting the gun inside the inventory while charging
	self.inventorySwapTimer = Timer();
	self.inventorySwapTimer:SetSimTimeLimitMS(math.ceil(TimerMan.DeltaTimeMS));
	self.activeSound = CreateSoundContainer("Worms Chargeup Sound", "Worms.rte");
end
function Update(self)
	if self.Magazine then
		if self.inventorySwapTimer:IsPastSimTimeLimit() then
			self.activeSound:Stop();
			self.charge = 0;
		end
		self.inventorySwapTimer:Reset();
		if self.Magazine.RoundCount > 0 then
			if self:DoneReloading() then
				self:Deactivate();
			end
			if self:IsActivated() and not self.forceFire then
				self:Deactivate();

				if self.activeSound:IsBeingPlayed() then
					self.activeSound.Pos = self.Pos;
					self.activeSound.Pitch = self.charge;
				else
					self.activeSound:Play(self.Pos);
				end
				if not self.chargeTimer:IsPastSimTimeLimit() then
					self.charge = self.chargeTimer.ElapsedSimTimeMS/self.chargeDelay;
				else
					self.charge = 1;
					self.forceFire = true;
				end
				self.Magazine.RoundCount = math.ceil(self.charge * 100);
			else
				self.Magazine.RoundCount = 1;
				if self.charge > 0 then
					--Trigger gun like normal and dispense the shot
					self:Activate();
				end
				self.chargeTimer:Reset();
			end
		else
			self:Reload();
		end
	end
	if self.FiredFrame then
		local shot = CreateMOSRotating(self.PresetName .. " Shot");
		shot.Team = self.Team;
		shot.IgnoresTeamHits = true;
		shot.Pos = self.MuzzlePos;
		shot.Vel = Vector((self.minFireVel + (self.maxFireVel - self.minFireVel) * self.charge) * self.FlipFactor, 0):RadRotate(self.RotAngle);
		MovableMan:AddParticle(shot);
		
		self.charge = 0;
		self.activeSound:Stop();
		
		self.forceFire = false;
	end
end
function Destroy(self)
	self.activeSound:Stop();
end