function GetJob()
  if Config.Framework == 'ProjectStarboy' then
    return Framework.PlayerData.job
  end
  if Config.Framework == "esx" then
    return Framework.GetPlayerData().job
  end
end
