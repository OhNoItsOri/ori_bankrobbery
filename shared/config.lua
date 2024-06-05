return {
    --Targetting
    debug = false,
    animDebug = true,
    resetDuration = 2,
    tarRadius = 0.5,
    minimumPolice = 0,
    panelItem = 'security_card_01',
    thermiteItem = 'thermite',
    lighterItem = 'lighter',
    lootDuration = 2000,
    lockerAmount = math.random(35000, 450000),
    dirtyItem = 'black_money',
    lockerItem = 'securitylaptop', -- this is for opening lockers
    lockerItem2 = 'pocketwatch',
    lockerItem3 = 'WEAPON_PISTOL_MK2',
    lockerItem4 = 'security_card_02',


    --Banking
    fleecaDoorModel = `v_ilev_gb_vauldr`,
    fleecaGateModel = `v_ilev_gb_vaubar`,
    vaultTime = 1, -- in minutes
    fleeca = {
        doors = { -- these are the vault doors and lockers
            { -- Legion
                coords = vec3(148.0226,-1044.364, 29.50693),
                heading = 250,
                openHeading = 160,
                isOpen = false,
                isRobbed = false,
                tarCash = {
                    vec3(146.6, -1049.01, 29.56),
                    vec3(147.25, -1050.35, 29.56),
                    vec3(148.97, -1051.02, 29.56),
                    vec3(150.38, -1050.53, 29.56)
                },
                tarItems = {
                    vec3(147.16, -1047.78, 29.56),
                    vec3(150.58, -1048.95, 29.56)
                }
            },
            {  -- Hawick
                coords = vec3(312.358, -282.7301, 54.30365),
                heading = 250,
                openHeading = 160,
                isOpen = false,
                isRobbed = false,
                tarCash = {
                    vec3(310.81, -287.82, 54.16),
                    vec3(311.96, -288.85, 54.16),
                    vec3(313.45, -289.51, 54.16),
                    vec3(314.67, -288.9, 54.16)
                },
                tarItems = {
                    vec3(315.15, -287.58, 54.16),
                    vec3(311.56, -286.19, 54.16)
                }
             },
             {  -- Hawick2/Sant Vitus
                coords = vec3(-352.7365, -53.57248, 49.17543),
                heading = 250,
                openHeading = 160,
                isOpen = false,
                isRobbed = false,
                tarCash = {
                   vec3(-354.26, -58.38, 49.04),
                   vec3(-353.78, -59.37, 49.04),
                   vec3(-351.48, -60.12, 49.04),
                   vec3(-350.6, -59.76, 49.04)
                },
                tarItems = {
                   vec3(-353.61, -57.16, 49.04),
                   vec3(-349.89, -58.3, 49.04)
                }
            },
            {  -- blvd Del perro
                coords = vec3(-1211.261, -334.5596, 37.91989),
                heading = 297,
                openHeading = 207,
                isOpen = false,
                isRobbed = false,
                tarCash = {
                    vec3(-1208.79, -338.91, 38.0),
                    vec3(-1207.36, -339.33, 38.0),
                    vec3(-1205.66, -338.32, 38.0),
                    vec3(-1205.18, -337.07, 38.0)
                },
                tarItems = {
                    vec3(-1209.41, -337.58, 38.0),
                    vec3(-1205.83, -335.78, 38.0)
                }
            },
            {  -- GOH
                coords = vec3(-2958.539, 482.2706, 15.83595),
                heading = 357,
                openHeading = 267,
                isOpen = false,
                isRobbed = false,
                tarCash = {
                    vec3(-2953.49, 482.25, 16.0),
                    vec3(-2952.39, 483.16, 16.0),
                    vec3(-2952.44, 485.33, 16.0),
                    vec3(-2953.35, 486.34, 16.0)
                },
                tarItems = {
                    vec3(-2954.94, 482.42, 16.0),
                    vec3(-2954.78, 486.53, 16.0)
                }
            },
            {  -- r68
                coords = vec3(1175.542, 2710.861, 38.22689),
                heading = 90,
                openHeading = 1,
                isOpen = false,
                isRobbed = false,
                tarCash = {
                    vec3(1175.29, 2716.19, 38.15),
                    vec3(1174.67, 2716.79, 38.15),
                    vec3(1172.31, 2716.91, 38.15),
                    vec3(1171.07, 2715.87, 38.15)
                },
                tarItems = {
                    vec3(1175.19, 2714.53, 38.15),
                    vec3(1171.12, 2714.34, 38.15)
                }
            },
        },
        panels = { -- security card panels
            {coords = vec3(146.79, -1045.99, 29.37), isRobbed = false}, --legion
            {coords = vec3(311.11, -284.27, 54.16), isRobbed = false}, --Hawick
            {coords = vec3(-353.88, -55.19, 49.04), isRobbed = false}, --Hawick2/sanvitus
            {coords = vec3(-1210.95, -336.52, 37.78), isRobbed = false}, --blvd Dell Perro
            {coords = vec3(-2956.62, 481.6, 15.7), isRobbed = false}, --GOH
            {coords = vec3(1176.06, 2712.77, 38.09), isRobbed = false}, --r68

        },
        gateDoor = { -- gate entity that opens with thermite 
            { --legion
                coords = vec3(150.3113, -1047.575, 29.67819),
                heading = 0,
                openHeading = 90,
                isOpen = false
            },
            {--Hawick
                coords = vec3(314.6438, -285.9401, 54.4749), 
                heading = 0,
                openHeading = 90,
                isOpen = false
            },
            { --Hawick2
                coords = vec3(-350.3954, -56.74229, 49.34669),
                heading = 0,
                openHeading = 90,
                isOpen = false
            },
            {--blvd Del Perro
                coords = vec3(-1207.354, -335.0772, 38.09115), 
                heading = 0,
                openHeading = 90,
                isOpen = false
            },
            { --goh
                coords = vec3(-2956.174, 485.4231, 16.0072), 
                heading = 0,
                openHeading = 90,
                isOpen = false
            },
            { --r68
                coords = vec3(1172.291, 2713.088, 38.39815), 
                heading = 0,
                openHeading = 90,
                isOpen = false
            },
        },
        gates = { --panel at the gates(thermite)
            {coords = vec3(148.53, -1046.3, 29.37), heading = 160.00,  isRobbed = false, gateName = 'fleecalegion'}, --legion
            {coords = vec3(313.42, -285.39, 54.16), heading = 160.00, isRobbed = false, gateName = 'fleecahawick'}, --Hawick
            {coords = vec3(-352.14, -55.51, 49.04), heading = 160.00, isRobbed = false, gateName = 'fleecahawick2'}, --Hawick2/sanvitus
            {coords = vec3(-1209.41, -335.48, 37.78), heading = 160.00, isRobbed = false, gateName = 'fleecahaperro'}, --Hawick2/sanvitus
            {coords = vec3(-2956.68, 484.17, 15.7), heading = 270.00, isRobbed = false, gateName = 'fleecahagoh'}, --Hawick2/sanvitus
            {coords = vec3(1174.36, 2712.45, 38.09), heading = 270.00, isRobbed = false, gateName = 'fleecahar68'}, --r68

        },
        thermite = { -- thermite placement
            {coords = vec3(148.9, -1047.0, 29.6), heading = 160.00}, --legion check placement
            {coords = vec3(313.3, -285.35, 54.45), heading = 160.00}, --Hawick placement good
            {coords = vec3(-351.7, -56.2, 49.35), heading = 160.00}, --Hawick2
            {coords = vec3(-1208.65, -335.65, 38.1), heading = 200.00}, --blvd del perro
            {coords = vec3(-2956.3, 484.05, 16.0), heading = 300.00}, --goh
            {coords = vec3(1173.6, 2713.0, 38.4), heading = 355.0}, --r68
        },
    },
}