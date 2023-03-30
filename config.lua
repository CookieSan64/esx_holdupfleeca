Config = {}
Config.Locale = 'fr'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 27    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 2
Config.TimerBeforeNewRob    = 2000 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 20   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["7185"] = {
		position = { x = -353.3107, y = -54.15171, z = 49.03651 },
		reward = 150, -- 1 mallette d'argent toutes les 2 secondes
		nameOfStore = "Fleeca 7185",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["7193"] = {
		position = { x = 311.8015, y = -283.2321, z = 54.16473 },
		reward = 150, -- 1 mallette d'argent toutes les 2 secondes
		nameOfStore = "Fleeca 7193",
		secondsRemaining = 300, -- secondes
		lastRobbed = 0
	},
	["7175"] = {
		position = { x = -1211.282, y = -335.2975, z = 37.78097 },
		reward = 150, -- 1 mallette d'argent toutes les 2 secondes
		nameOfStore = "Fleeca 7175",
		secondsRemaining = 300, -- secondes
		lastRobbed = 0
	},
	["8170"] = {
		position = { x = 147.3033, y = -1045.095, z = 29.368 },
		reward = 150, -- 1 mallette d'argent toutes les 2 secondes
		nameOfStore = "Fleeca 8170",
		secondsRemaining = 300, -- secondes
		lastRobbed = 0
	},
	["5070"] = {
		position = { x = -2957.793, y = 481.9275, z = 15.69701 },
		reward = 150, -- 1 mallette d'argent toutes les 2 secondes
		nameOfStore = "Fleeca 5070",
		secondsRemaining = 300, -- secondes
		lastRobbed = 0
	},
	["2024"] = {
		position = { x = 1175.892, y = 2711.627, z = 38.08797 },
		reward = 150, -- 1 mallette d'argent toutes les 2 secondes
		nameOfStore = "Fleeca 2024",
		secondsRemaining = 300, -- secondes
		lastRobbed = 0
	}

}
