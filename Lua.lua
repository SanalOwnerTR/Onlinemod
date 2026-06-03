_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "5.0"

local Yargi = {}
Yargi.FakeInstBase = 2000000000
Yargi.StartInstId = Yargi.FakeInstBase

function Yargi.GetFallbackPacket()
	local packet = {}
	local instId = Yargi.FakeInstBase
	
	-- Acil durum listesi: Sadece en onemli esyalar. Internet indirmesi bitene kadar lobide bos kalmamasi icin.
	local manual = {
		1010041, 1010042, 1010043, 1010044, 1010045, 1010046, 1010047, 1010048, 1010049, 10100410, 10100411, 10100412,
		1406469, 1406470, 1406471, 1406472, 1406473, 1406474, 1406475,
		1406638, 1406639, 1406640, 1406641, 1406642, 1406643, 1406711, 1406712, 1406713, 1406714, 1406715, 1406716, 
		1406810, 1406811, 1406812, 1406813, 1406814, 1406815, 1406872, 
		1406965, 1406966, 1406967, 1406968, 1406969, 1406970, 1406971, 
		1407097, 1407098, 1407099, 1407100, 1407101, 1407102, 1407103, 
		1407140, 1407141, 1407142, 1407213, 1407214, 1407215, 1407216, 1407217, 1407218, 1407219, 
		1407253, 1407254, 1407255, 1407256, 1407257, 1407258, 1407259
	}
	
	for i = 1, #manual do
		instId = instId + 1
		packet[instId] = {
			res_id = manual[i],
			count = 1, lock_cnt = 0, isnew = 0, valid_hours = 0, expire_ts = 0,
			color = 0, pattern = 0, notified_3day = 0, notified_1week = 0
		}
	end
	
	Yargi.StartInstId = instId
	return packet
end

function Yargi.DownloadFromGithubAndInject()
	pcall(function()
		local ModuleManager = _G.ModuleManager or require("client.slua.logic.common.ModuleManager")
		local http_manager = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.http_manager)
		if http_manager then
			local url = "https://raw.githubusercontent.com/SanalOwnerTR/Onlinemod/main/DumpSkin.h"
			http_manager:Get(url, {}, "", nil, function(success, data, content)
				if success and content then
					local packet = {}
					local instId = Yargi.StartInstId
					
					for line in string.gmatch(content, "[^\r\n]+") do
						local idStr = line:match("^(%d+)")
						if idStr then
							local resId = tonumber(idStr)
							if resId and resId > 10000 then
								instId = instId + 1
								packet[instId] = {
									res_id = resId,
									count = 1, lock_cnt = 0, isnew = 0, valid_hours = 0, expire_ts = 0,
									color = 0, pattern = 0, notified_3day = 0, notified_1week = 0
								}
							end
						end
					end
					
					pcall(function()
						local wardrobe = package.loaded["client.slua.logic.wardrobe.wardrobe_data"] or _G.wardrobe_data
						if wardrobe and wardrobe.GetHallDepotItemData then
							local depot = wardrobe:GetHallDepotItemData()
							if depot and depot.AddData then
								for _, v in pairs(packet) do
									pcall(depot.AddData, depot, v)
								end
							end
						end
					end)
					
					pcall(function()
						local GlobalUIFunctionLibrary = _G.GlobalUIFunctionLibrary or require("client.slua.umg.common.GlobalUIFunctionLibrary")
						if GlobalUIFunctionLibrary and GlobalUIFunctionLibrary.ShowSystemTips then
							GlobalUIFunctionLibrary.ShowSystemTips("YARGI: Internet'ten " .. tostring(instId - Yargi.StartInstId) .. " Skin Indirildi ve Envantere Eklendi!")
						end
					end)
				end
			end)
		end
	end)
end

function Yargi.MakePermanent()
	pcall(function()
		local lgd_wpn = package.loaded["client.slua.logic.wardrobe.logic_legend_weapon"] or _G.logic_legend_weapon
		if not lgd_wpn then
			local ok, res = pcall(require, "client.slua.logic.wardrobe.logic_legend_weapon")
			if ok then lgd_wpn = res end
		end
		if lgd_wpn then
			if lgd_wpn.GetPermissionType then
				lgd_wpn.GetPermissionType = function() return 4 end
			end
			if lgd_wpn.GetActivateStatus then
				lgd_wpn.GetActivateStatus = function() return 4 end
			end
			if lgd_wpn.IsLgdWpnValid then
				lgd_wpn.IsLgdWpnValid = function() return true end
			end
			if lgd_wpn.CheckValidity then
				lgd_wpn.CheckValidity = function() return true end
			end
			if lgd_wpn._HasPermanentCard then
				lgd_wpn._HasPermanentCard = function() return true end
			end
		end
	end)
	
	pcall(function()
		local lgd_suit = package.loaded["client.slua.logic.wardrobe.logic_legend_suit"] or _G.logic_legend_suit
		if not lgd_suit then
			local ok, res = pcall(require, "client.slua.logic.wardrobe.logic_legend_suit")
			if ok then lgd_suit = res end
		end
		if lgd_suit then
			if lgd_suit.GetPermissionType then
				lgd_suit.GetPermissionType = function() return 4 end
			end
			if lgd_suit.GetActivateStatus then
				lgd_suit.GetActivateStatus = function() return 4 end
			end
			if lgd_suit.IsLgdSuitValid then
				lgd_suit.IsLgdSuitValid = function() return true end
			end
			if lgd_suit.CheckValidity then
				lgd_suit.CheckValidity = function() return true end
			end
			if lgd_suit._HasPermanentCard then
				lgd_suit._HasPermanentCard = function() return true end
			end
		end
	end)
	
	pcall(function()
		local xsuit = package.loaded["client.slua.logic.xsuit.logic_xsuit"] or _G.logic_xsuit
		if not xsuit then
			local ok, res = pcall(require, "client.slua.logic.xsuit.logic_xsuit")
			if ok then xsuit = res end
		end
		if xsuit then
			if xsuit.IsLgdSuitValid then xsuit.IsLgdSuitValid = function() return true end end
			if xsuit.CheckValidity then xsuit.CheckValidity = function() return true end end
		end
	end)
end

function Yargi.HookWardrobeData(module)
	if type(module) ~= "table" or module._yargiHooked then return end
	module._yargiHooked = true
	local old_InitHallDepotData = module.InitHallDepotData
	if old_InitHallDepotData then
		module.InitHallDepotData = function(self, arrayItemDataPackage)
			local fakePacket = Yargi.GetFallbackPacket()
			table.insert(arrayItemDataPackage, fakePacket)
			
			pcall(function()
				local GlobalUIFunctionLibrary = _G.GlobalUIFunctionLibrary or require("client.slua.umg.common.GlobalUIFunctionLibrary")
				if GlobalUIFunctionLibrary and GlobalUIFunctionLibrary.ShowSystemTips then
					GlobalUIFunctionLibrary.ShowSystemTips("YARGI: Altyapi Hazir, Internet'ten Skinler Bekleniyor...")
				end
			end)
			
			return old_InitHallDepotData(self, arrayItemDataPackage)
		end
	end
end

function Yargi.Init()
	if not _G.YARGI_ALIVE then return end

	local old_require = _G.require
	_G.require = function(name)
		local module = old_require(name)
		if name == "client.slua.logic.wardrobe.wardrobe_data" then
			Yargi.HookWardrobeData(module)
		end
		return module
	end

	local existing = package.loaded["client.slua.logic.wardrobe.wardrobe_data"]
	if existing then
		Yargi.HookWardrobeData(existing)
	end
	
	Yargi.MakePermanent()
	Yargi.DownloadFromGithubAndInject()
end

Yargi.Init()
return Yargi
