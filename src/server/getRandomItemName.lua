local modifiers = {
	"Rusty",
	"Evil",
	"Dull",
	"Moldy",
	"Sparkly",
	"Broken",
	"Soggy",
	"Unyielding",
	"Balanced",
	"Rare",
	"Worn",
	"Puzzling",
	"Sticky",
}

local materials = {
	"Granite",
	"Wooden",
	"Leather",
	"Iron",
	"Steel",
	"Plastic",
	"Cloth",
}

local subjects = {
	"Sword",
	"Spear",
	"Mace",
	"Greatsword",
	"Shield",
	"Boots",
	"Helmet",
	"Chestplate",
	"Pauldrons",
	"Gauntlets",
	"Mask",
	"Hood",
	"Robe",
	"Loaf of Bread",
}

local sources = {
	"Time",
	"Power",
	"Darkness",
	"Greatness",
	"Enigmas",
	"Justice",
	"Disruption",
}

local function chooseFrom(list)
	return list[math.random(1, #list)]
end

local function getRandomItemName()
	local material = chooseFrom(materials)
	local subject = chooseFrom(subjects)

	local name = string.format("%s %s", material, subject)

	if math.random(1, 4) == 1 then
		local modifier = chooseFrom(modifiers)
		name = string.format("%s %s", modifier, name)
	end

	if math.random(1, 7) == 1 then
		local source = chooseFrom(sources)
		name = string.format("%s of %s", name, source)
	end

	return name
end

return getRandomItemName