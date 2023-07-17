Config = {}

Config.DepositAmount = 50

Config.TaxiPed = {
  pedmodel = "a_m_m_prolhost_01",
  coords = vector4(886.9362, -155.1806, 76.89115, 250.4603),
}

Config.Targets = {
  [1] = {
    pos = vector3(886.92, -155.13, 76.89),
    length = 0.8,
    width = 1.0,
    name = "taxi_start",
    heading = 60.0,
    minZ = 73.89,
    maxZ = 77.89,
  },
}

Config.locations = {
  {
    startLocation = { x = 457.5933, y = 15.36011, z = 86.62774, h = 238.6221 },
    endLocation = { x = -1.193556, y = 3.531912, z = 70.56966 },
    minSalary = 100,
    maxSalary = 500,
    pedModel = "a_f_m_fatcult_01"
  },
  {
    startLocation = { x = -87.58224, y = 270.3537, z = 99.9417, h = 186.3017 },
    endLocation = { x = -1.193556, y = 3.531912, z = 70.56966 },
    minSalary = 200,
    maxSalary = 600,
    pedModel = "a_c_chimp"
  },
  {
    startLocation = { x = -240.135, y = 159.9634, z = 72.62188, h = 268.6601 },
    endLocation = { x = -1.193556, y = 3.531912, z = 70.56966 },
    minSalary = 300,
    maxSalary = 700,
    pedModel = "cs_hunter"
  }
}

Config.Clothes = {
  male = {
    torso_1 = 57,
    torso_2 = 0,
    decals_1 = 0,
    decals_2 = 0,
    undershirt_1 = 15,
    undershirt_2 = 0,
    arms = 20,
    pants_1 = 9,
    pants_2 = 0,
    shoes_1 = 25,
    shoes_2 = 0,
    helmet_1 = 20,
    helmet_2 = 0,
    bproof_1 = 0,
    bproof_2 = 0,
    bags_1 = 40,
    bags_2 = 0
  },
  female = {
    torso_1 = 165,
    torso_2 = 0,
    decals_1 = 0,
    decals_2 = 0,
    undershirt_1 = 15,
    undershirt_2 = 0,
    arms = 20,
    pants_1 = 11,
    pants_2 = 0,
    shoes_1 = 26,
    shoes_2 = 0,
    helmet_1 = 21,
    helmet_2 = 2,
    bproof_1 = 0,
    bproof_2 = 0,
    bags_1 = 40,
    bags_2 = 0,
    chain_1 = 0,
    chain_2 = 0,
    ears_1 = 0,
    ears_2 = 0
  }
}
