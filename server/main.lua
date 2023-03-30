local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ServerConfig = {
    webhooks = "https://discord.com/api/webhooks/1090280022222311494/qKpS0iWJXa7Z_XHjCBdqpIJduh7bd7i990Yb1PSF8ml5Ed1bKzwZQE6Wi1XYGi4XwN0f",
    webhooksTitle = "Braquage de Fleeca",
    webhooksColor = 3066993,
	webhooksColor2 = 2303786,
	webhooksColor3 = 15548997,
}

ServerToDiscord = function(name, message, color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = ServerConfig.webhooks

    local embeds = {
	    {
		    ["title"]= message,
		    ["type"]="rich",
		    ["color"] =color,
		    ["footer"]=  {
			["text"]= "Heure : " ..date_local.. "",
		    },
	    }
    }

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 


--

RegisterServerEvent('esx_holdupfleeca:robberyStarted')
AddEventHandler('esx_holdupfleeca:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local timeElapsed = 0

	if Stores[currentStore] then
		local store = Stores[currentStore]

		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastRobbed)))
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'sheriff1' or xPlayer.job.name == 'fbi' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= Config.PoliceNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'sheriff1' or xPlayer.job.name == 'fbi' then
						TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog', store.nameOfStore))
						TriggerClientEvent('esx_holdupfleeca:setBlip', xPlayers[i], Stores[currentStore].position)
					end
				end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', store.nameOfStore))
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_triggered'))

				TriggerClientEvent('esx_holdupfleeca:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('esx_holdupfleeca:startTimer', _source)

				Stores[currentStore].lastRobbed = os.time()
				robbers[_source] = currentStore

				ServerToDiscord(ServerConfig.webhooksTitle, '[Braquage Lancé] __'  ..xPlayer.getName().. '__ vient de lancer un braquage de Fleeca (`'..store.nameOfStore..'`)', ServerConfig.webhooksColor)

				SetTimeout(2000, function()
					while robbers[_source] and timeElapsed < store.secondsRemaining do
						xPlayer.addInventoryItem('moneycase', 1)
						timeElapsed = timeElapsed + 2
						Citizen.Wait(2000)
					end
				end)		

				SetTimeout(store.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							local nbMoneyCases = 0
							SetTimeout(2000, function()
								while robbers[_source] and timeElapsed < store.secondsRemaining do
									xPlayer.addInventoryItem('moneycase', 1)
									nbMoneyCases = nbMoneyCases + 1
									timeElapsed = timeElapsed + 2
									Citizen.Wait(2000)
								end
								TriggerClientEvent('esx_holdupfleeca:robberyComplete', _source, 150)
								if Config.GiveBlackMoney then
									ServerToDiscord(ServerConfig.webhooksTitle, '[Braquage Réussi] __' ..xPlayer.getName().. '__ vient de réussir son braquage de la Fleeca : (`'..store.nameOfStore..'`) il a obtenu 150 malette d\'argent', ServerConfig.webhooksColor2)
								end
							end)

							if not Config.GiveBlackMoney then
								SetTimeout(5000, function()
									xPlayer.addInventoryItem('moneycase', 1)
								end)
							end
						end
						local xPlayers, xPlayer = ESX.GetPlayers(), nil
						for i=1, #xPlayers, 1 do
							xPlayer = ESX.GetPlayerFromId(xPlayers[i])
							if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'sheriff1' or xPlayer.job.name == 'fbi' then
								TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_complete_at', store.nameOfStore))
								TriggerClientEvent('esx_holdupfleeca:killBlip', xPlayers[i])
							end
						end
					end
				end)
			end
		end
	end
end)

RegisterServerEvent('esx_holdupfleeca:tooFar')
AddEventHandler('esx_holdupfleeca:tooFar', function(currentStore)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'sheriff1' or xPlayer.job.name == 'fbi' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
			TriggerClientEvent('esx_holdupfleeca:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_holdupfleeca:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
		ServerToDiscord(ServerConfig.webhooksTitle, '[Braquage Annulé] de la Fleeca (`'..Stores[currentStore].nameOfStore..'`)', ServerConfig.webhooksColor3)
	end
end)

