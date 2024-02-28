function HasItem(player, itemName, amount)
  if Config.Framework == 'ProjectStarboy' then
    return player.hasItem({
      itemName = itemName,
      amount = amount
    })
  elseif Config.Framework == 'esx' then
    local xItem = player.hasItem(itemName)
    if not xItem then return false end
    return xItem.count >= amount
  end
end

function RemoveItem(player, itemName, amount)
  if Config.Framework == 'ProjectStarboy' then
    return player.removeInventoryItem({
      itemName = itemName,
      amount = amount
    })
  elseif Config.Framework == 'esx' then
    return player.removeInventoryItem(itemName, amount)
  end
end

function AddMoney(player, amount)
  if Config.Framework == 'ProjectStarboy' then
    return player.addAccountMoney("money", amount)
  elseif Config.Framework == 'esx' then
    return player.addMoney(amount)
  end
end

function GetPlayerFromId(playerSrc)
  if Config.Framework == 'ProjectStarboy' then
    return Framework.GetPlayerFromSource(playerSrc)
  elseif Config.Framework == 'esx' then
    return Framework.GetPlayerFromId(playerSrc)
  end
end

function ShowNotification(player, msg)
  return player.showNotification(msg)
end
