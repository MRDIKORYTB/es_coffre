-------------------|
-------------------|
---------FX--------|
--BY_MR_DIKOR_YTB--|
-------------------|
-------------------|

function idJob(player)
  local result = MySQL.Sync.fetchAll("SELECT identifier, job_id, job_name FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = @identifier", {['@identifier'] = player})
  return tostring(result[1].job_id)
end

function updateCoffreBuch(player, prixavant,prixtotal,prixajoute)
  MySQL.Async.execute("UPDATE coffrebuch SET `solde`=@prixtotal , identifier = @identifier , lasttransfert = @prixajoute WHERE solde = @prixavant AND id = '3' ",{['@prixtotal'] = prixtotal, ['@identifier'] = player ,['@prixajoute'] = prixajoute,['@prixavant'] = prixavant })

end

function GetSolde()
  local result = MySQL.Sync.fetchAll("SELECT solde FROM coffrebuch WHERE id ='3'")
  return tostring(result[1].solde)
end

function GetCaBuch()
  local result = MySQL.Sync.fetchAll("SELECT ca FROM coffrebuch WHERE id ='3'")
  return tostring(result[1].ca)
end

function GetSaleBuch()
  local result = MySQL.Sync.fetchAll("SELECT sale FROM coffrebuch WHERE id ='3'")
  return tostring(result[1].sale)
end

function ajoutAmendeToCoffreBuch(solde,sale,ca)
  MySQL.Async.execute("UPDATE coffrebuch SET `solde`='@solde',ca='@ca',sale='@sale',identifier=@identifier  WHERE id = '3' ",{['@solde'] = solde, ['@identifier'] = player ,['@ca'] = ca,['@sale'] = sale })

end

function blanchimentBuch(solde,sale,ca)
  MySQL.Async.execute("UPDATE coffrebuch SET `solde`='@solde',sale='@sale',identifier=@identifier  WHERE id = '3' ",{['@solde'] = solde, ['@identifier'] = player ,['@sale'] = sale })

end

RegisterServerEvent('coffrebuch:transform')
AddEventHandler('coffrebuch:transform', function (amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.getIdentifier()
    local idjob = idJob(player) 
 
 -- Here change id Job (allowed to withdraw/deposit )
    if(idjob == '33')then
      local amountblan = 0
      local amountblan = amount
      if user:dirty_money >= tonumber(amountblan) then
        local maxsale = 0
        local maxsale = GetSaleBuch()
        local solde = 0
        local solde = GetSoldeBuch()
        if tonumber(maxsale) >= tonumber(amountblan) then
          local restesale = 0
          local restesale = tonumber(maxsale) - tonumber(amountblan)
          local newsolde = 0
          local newsolde = tonumber(solde) + tonumber(amountblan)
          blanchimentBuch(tonumber(newsolde),tonumber(restesale))
          user:removeDirty_Money(tonumber(amountblan))
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous avez blanchi : "..amountblan.." ~g~€")
        
        else
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Trop d'argent sale à blanchir")
        end
      else
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous n'avez pas suffisament d'argent sale")
      end
    else
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas la permisison !")
    end 
  end)
end)



RegisterServerEvent('coffrebuch:amendecoffre')
AddEventHandler('coffrebuch:amendecoffre', function(amount)
  local solde = 0
  local ca = 0
  local sale = 0
  local amountcoffre = 0
  local totalsolde = 0
  local totalca = 0
  local totalsale = 0
  local solde = GetSoldeBuch()
  local ca = GetCaBuch()
  local sale = GetSaleBuch()
  local amountcoffre = amount
  local totalsolde = amountcoffre + solde
  local totalca = amountcoffre + ca
  local totalsale = amountcoffre + sale
  ajoutAmendeToCoffreBuch(totalsolde,totalsale,totalca)
  TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous avez rajouter : "..amountcoffre.." ~g~€")
  
end)


RegisterServerEvent('coffrebuch:getsolde')
AddEventHandler('coffrebuch:getsolde',function()
TriggerEvent('es:getPlayerFromId', source, function(user)

    local player = user.getIdentifier()
    local idjob = idJob(player)
 
 -- Here change id Job (allowed to withdraw/deposit )
    if(idjob == '33')then
      -- (idjob == '17'or idjob =='18')
      local datasolde = 0
      local dataca = 0
      local datasale = 0
      local datasolde = GetSoldeBuch()
      local dataca = GetCaBuch()
      local datasale = GetSaleBuch()
      print(datasolde)
      print(dataca)
      print(datasale)
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre LBDL", false, "Chiffre d'affaire total : "..dataca.."~g~€")
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre LBDL co", false, "Solde restant : "..datasolde.."~g~€")
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre LBDL co", false, "Argent Blanchissable : "..datasale.."~g~€")

    else
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas la permisison !")
    end
end)
end)

RegisterServerEvent('coffrebuch:ajoutsolde')
AddEventHandler('coffrebuch:ajoutsolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)

    local player = user.getIdentifier()
    local idjob = idJob(player)
 
 -- Here change id Job (allowed to withdraw/deposit )
    if(idjob == '33')then
      -- (idjob == '17'or idjob =='18')
      local prixavant = 0
      local prixajoute = 0
      local prixtotal = 0
      local prixavant = GetSoldeBuch()
      local prixajoute = ajout
      local prixtotal = prixavant + prixajoute
     
      print(player)
      print(prixavant)
      print(prixajoute)
      print(prixtotal)

      if((user.money - prixajoute)>=0)then
     
        user:removeMoney((prixajoute))

        updateCoffreBuch(player,prixavant,prixtotal,prixajoute)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous avez rajouter : "..prixajoute.." ~g~€")
      else
         TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas assez d'argent !")

      end
    else
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas la permisison !")
    end
end)
end)

RegisterServerEvent('coffrebuch:retirersolde')
AddEventHandler('coffrebuch:retirersolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.getIdentifier()
    local idjob = idJob(player)
 -- Here change id Job (allowed to withdraw/deposit )
     --(idjob == '23'or idjob =='18')
    if(idjob == '33')then

      local prixavant = 0
      local prixenleve = 0
      local prixtotal = 0
      local prixavant = GetSoldeBuch()
      local prixenleve = ajout
      local prixtotal = prixavant-prixenleve
     
      print(player)
      print(prixavant)
      print(prixenleve)
      print(prixtotal)
    

      if(prixtotal<-1)then
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Coffre vide !")
        
      else
        

        updateCoffreBuch(player,prixavant,prixtotal,prixenleve)
        user:addMoney((prixenleve))
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous avez enlever : "..prixenleve.." ~r~€")
      end
    else
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas la permisison !")
    end


end)
end)



