Config = {}

Config.Location = vector3(5148.01, -5032.9, 4.92)
Config.Radius = 1400.0 

-- Kullanılabilir silah
Config.AllowedWeapon = "weapon_heavypistol"

Config.job1 = "police"
Config.job1color = 26

--Job 2
Config.job2 = "lssd"
Config.job2color = 46

--Job 3
Config.job3 = "sapr"
Config.job3color = 69

Config.RedZoneCoords = vector3(2779.03, 1546.96, 30.79) -- Bölgenin merkezi
Config.RedZoneRadius = 250.0 -- Bölge yarıçapı (metre)
Config.RedZoneDamageInterval = 1 -- Hasar sıklığı (ms)
Config.RedZoneDamageAmount = 1 -- Hasar miktarı

Config.Distance = 2  -- Yazı gözükme mesafesi

Config.Depolar = {
    [1] = {
        id = 'İSİM',
        label = 'Depo',
        slots = 500,
        weight = 100000000,
        personal = false,
        jobs = true,
        jobs = "meslek",
        shared = true,
        coords = vector3("vector3 çekiceksin")
    },
}

-- araç kirala
Config.setupMenu = 'qb-menu' -- qb-menu / nh-context

Config.vehicleList = {
    { name = "Asea", model = "Asea", price = 500 },
}

Config.BoatList = {
    { name = "jetmax", model = "jetmax", price = 500 },
}

-- Blips 
Config.Locations = {
}

Config.Locations2 = {
}

Config.vehicleSpawn = {
    --- AirPort 
    [1] = { 
		workSpawn = {
			coords = vector3(-1040.42, -2726.56, 20.07),
			heading = 240.54,
		},
	},
    --- Marathon Avenue
    [2] = {
		workSpawn = {
			coords = vector3(-1448.17, -675.7, 25.79),
			heading = 214.17,
		},
	},--vector3(-466.36, -642.75, 32.39)
    [3] = {
		workSpawn = {
			coords = vector3(-447.81, -682.1, 31.81),
			heading = 0.58,
		},
	},
}

Config.boatspawn = {
    --- İskele 
    [1] = { 
		workSpawn2 = {
			coords = vector3(-1795.71, -1232.61, 2.28),
			heading = 321.27,
		},
	},
}


Config.rentacarped = {
    [1] = {
        model = "s_m_y_valet_01",
        pos = vector3(-1039.23, -2730.67, 12.76),
        heading = 288.48,
        handle = nil
    },
    [2] = {
        model = "s_m_y_valet_01",
        pos = vector3(-1442.22, -674.19, 25.53),
        heading = 213.33,
        handle = nil
    },
    [2] = {
        model = "s_m_y_valet_01",
        pos = vector3(-474.49, -679.24, 31.71),
        heading = 359.9,
        handle = nil
    },
}

Config.rentacarboatped = {
    [1] = {
        model = "s_m_y_valet_01",
        pos = vector3(-1798.71, -1224.71, 0.6),
        heading = 321.45,
        handle = nil
    },
}