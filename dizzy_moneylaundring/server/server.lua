ESX = exports["es_extended"]:getSharedObject()

stressyo = true
local input = nil
local inprogress = 0
local timer = 0
local finalreturn = 0


Citizen.CreateThread(function()
while true do
		Citizen.Wait(1000)
		if timer > 0 then
			timer = timer - 1000
		end
	end
end)

----------------------------------------------------------------
ESX.RegisterServerCallback('checkstate',function(source, cb)
    cb(inprogress)
  end)
  -----------------------------------------------------------------
  
ESX.RegisterServerCallback('checkstate_timer',function(source, cb)
      cb(timer)
  end)
  ----------------------------------------------------------------
  
  RegisterNetEvent('moneywashevent')
AddEventHandler('moneywashevent', function(input)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source) 
  local myBlackMoney = xPlayer.getAccount('black_money').money
  local choice = tonumber(input)
  local choice_ = round(choice)
  local cleancash = choice_ * Config.Rate
  finalreturn = round(cleancash)

  if choice_ >= Config.MinimumBlackMoney then
    if choice <= myBlackMoney then
      TriggerClientEvent('animationxd', _source)
      Wait(Config.ProgressbarTime * 1000)
      xPlayer.removeAccountMoney('black_money', choice_)
      
      if Config.Notifications == "okok" then
        TriggerClientEvent('okokNotify:Alert', _source, "", Config.YouPutIn ..choice_.." dirty cash!", 5000, 'info')
        -- Additional TriggerClientEvent code here when Config.Notifications == "okok"
      else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = Config.YouPutIn ..choice_.." dirty cash!", style = { ['background-color'] = '#3d66b4', ['color'] = '#ffffff' } })
        -- Additional TriggerClientEvent code here when Config.Notifications != "okok"
      end
      
      inprogress = inprogress + 1
      timer = Config.WashingTime * 1000
    else
      if Config.Notifications == "okok" then 
        TriggerClientEvent('okokNotify:Alert', source, "", Config.NotEnough, 5000, 'info')
      else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = Config.NotEnough, style = { ['background-color'] = '#3d66b4', ['color'] = '#ffffff' } })
      end
    end
  else 
    if Config.Notifications == "okok" then 
      TriggerClientEvent('okokNotify:Alert', source, "", "Minimum to wash is "..Config.MinimumBlackMoney..'', 5000, 'info')
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = "Minimum to wash is "..Config.MinimumBlackMoney..'', style = { ['background-color'] = '#3d66b4', ['color'] = '#ffffff' } })
    end
  end
end)
  
  
  
RegisterNetEvent('collectcash')
AddEventHandler('collectcash', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source) 

TriggerClientEvent('collecting_anim', _source)
Wait(Config.Collectingtime * 1000)
xPlayer.addMoney(finalreturn)
-- TriggerClientEvent('okokNotify:Alert', source, "", "Minimum to wash is "..Config.MinimumBlackMoney..'', 5000, 'info')
TriggerClientEvent('okokNotify:Alert', _source, "", Config.YouGot ..finalreturn.. Config.FromTheWashMachine, 5000, 'info')
-- TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = Config.YouGot ..finalreturn.. Config.FromTheWashMachine, style = { ['background-color'] = '#3d66b4', ['color'] = '#ffffff' } })
inprogress = 0
timer = 0

end)






function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
  end
  
  
  