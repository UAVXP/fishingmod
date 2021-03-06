fishingmod.AddCatch{
	friendly = "Portal Radio",
	type = "fishing_mod_catch_portalradio",
	rareness = 1000, 
	yank = 100, 
	mindepth = 100, 
	maxdepth = 20000,
	expgain = 25,
	levelrequired = 2,
	remove_on_release = false,
	value = 50,
	bait = {
		"models/props_radiostation/radio_antenna01_stay.mdl",
		--"models/props_misc/antenna03.mdl",
		--"models/props/de_dust/du_antenna_A.mdl",
		--"models/props_hydro/satellite_antenna01.mdl"	
	},
}

local ENT = {}

ENT.Type = "anim"
ENT.Base = "fishing_mod_base"

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/radio_reference.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self.shot = false
		self.sound = CreateSound(self, "ambient/music/looping_radio_mix.wav")
		self.sound:SetSoundLevel(100)
		self.sound:Play()
	end

	ENT.DeathSounds = {
		"ambient/dinosaur_fizzle.wav",
		"ambient/dinosaur_fizzle2.wav",
		"ambient/dinosaur_fizzle3.wav"
	}
	
	function ENT:Think()
		if self.shot == true then
			for key, entity in pairs(ents.FindInSphere(self:GetPos(), 15)) do
				if entity:GetModel() and string.find(entity:GetModel():lower(), "wrench") then
						local effectdata = EffectData()
						effectdata:SetOrigin( self:GetPos() + (self:GetUp() * 5) )
						effectdata:SetMagnitude( 4 )
						effectdata:SetScale( 1 )
						effectdata:SetRadius( 1 ) 
						util.Effect( "Sparks", effectdata )
						entity:Remove()
						self.shot = false
						self.sound = CreateSound(self, "ambient/music/looping_radio_mix.wav")
						self.sound:SetSoundLevel(100)
						self.sound:Play()
				end
			end
		end
	end

	function ENT:OnTakeDamage()
		if not self.shot then
			self:EmitSound(table.Random(self.DeathSounds),70,100)
		end
		self.shot = true
		self.sound:Stop()
	end

	function ENT:OnRemove()
		self.sound:Stop()
		if not self.shot then
			self:EmitSound(table.Random(self.DeathSounds),50,100)
		end
	end
end

scripted_ents.Register(ENT, "fishing_mod_catch_portalradio", true)