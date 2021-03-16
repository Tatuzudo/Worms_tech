function WindScript:StartScript()
	self.maxWind = 1;
	self.windChangeRate = 0.01;
	Wind = 0;
end
function WindScript:UpdateScript()
	Wind = Wind * 0.999 + RangeRand(-self.maxWind, self.maxWind) * self.windChangeRate;
	if math.abs(Wind) > self.maxWind then
		Wind = Wind > 0 and self.maxWind or -self.MaxWind;
	end
	--To-do: create a fancier system, add GUI indicator
end