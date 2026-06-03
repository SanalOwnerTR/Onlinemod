/unmute @t_G.YARGI_ALIVE = true
_G.YargiEngine = _G.YargiEngine or {}
_G.YargiEngine.Version = "4.0"

local Yargi = {}
Yargi.FakeInstBase = 2000000000
Yargi.DumpedItems = nil

local function SkinDumpkod()
	pcall(function()
		local async = require("client.common.async")
		async.Run(function(co)
			local packageName = "com.tencent.ig" 
			pcall(function()
				if UE4 and UE4.UKismetSystemLibrary then
					packageName = UE4.UKismetSystemLibrary.GetGameName()
				end
			end)

			local dumpPath = "/data/share1/SRCHUB_Dump.txt"
			local file, err = io.open(dumpPath, "w")
			if not file then
				dumpPath = "/data/share1/SkinDump.txt"
				file, err = io.open(dumpPath, "w")
				if not file then return end
			end

			local count = 0
			local itemsProcessed = 0
			local batchLimit = 0x999999999

			local backpack = nil
			pcall(function() backpack = UE4.UBackpackUtils.StaticClass() end)

			if backpack then
				local items = backpack:GetItemIDs()
				if items then
					local num = items:Num()
					for i = 0, num - 1 do
						local itemID = items:Get(i)
						local data = backpack:GetItemRecord(itemID)
						if data and data.BPID ~= 0 then
							local name = data.ItemName
							if type(name) == "userdata" and name.ToWString then
								name = name:ToWString()
							end
							file:write(tostring(itemID) .. " | " .. tostring(name) .. "\n")
							count = count + 1
						end

						itemsProcessed = itemsProcessed + 1
						if itemsProcessed >= batchLimit then
							itemsProcessed = 0
							async.Yield(co) 
						end
					end
				end
			else
				local CDataTable = _G.CDataTable or require("common.CDataTable")
				local ItemTable = CDataTable.GetTable("Item")
				if ItemTable then
					for id, v in pairs(ItemTable) do
						if v.BPID and v.BPID ~= 0 then
							local name = v.ItemName or "Unknown"
							if type(name) == "userdata" and name.ToWString then
								name = name:ToWString()
							end
							file:write(tostring(v.ID or id) .. " | " .. tostring(name) .. "\n")
							count = count + 1
							
							itemsProcessed = itemsProcessed + 1
							if itemsProcessed >= batchLimit then
								itemsProcessed = 0
								async.Yield(co)
							end
						end
					end
				end
			end
	
			file:close()
		end)
	end)
end

function Yargi.GetDumpedItems()
	if Yargi.DumpedItems then return Yargi.DumpedItems end
	local packet = {}
	local instId = Yargi.FakeInstBase
	
	pcall(function()
		local CDataTable = _G.CDataTable or require("common.CDataTable")
		local ItemTable = CDataTable.GetTable("Item")
		if ItemTable then
			for id, v in pairs(ItemTable) do
				local numId = tonumber(id) or tonumber(v.ID)
				if numId then
					instId = instId + 1
					packet[instId] = {
						res_id = numId,
						count = 1,
						lock_cnt = 0,
						isnew = 0,
						valid_hours = 0,
						expire_ts = 2147483647,
						color = 0,
						pattern = 0,
						notified_3day = 0,
						notified_1week = 0
					}
				end
			end
		end
	end)

	if instId == Yargi.FakeInstBase then
		local manual = {
			1406469, 1406470, 1407140, 1407141, 1010041, 10100410
		}
		for i = 1, #manual do
			instId = instId + 1
			packet[instId] = {
				res_id = manual[i],
				count = 1, lock_cnt = 0, isnew = 0, valid_hours = 0, expire_ts = 2147483647,
				color = 0, pattern = 0, notified_3day = 0, notified_1week = 0
			}
		end
	end
	
	Yargi.DumpedItems = packet
	return packet
end

function Yargi.HookWardrobeData(module)
	if type(module) ~= "table" or module._yargiHooked then return end
	module._yargiHooked = true
	local old_InitHallDepotData = module.InitHallDepotData
	if old_InitHallDepotData then
		module.InitHallDepotData = function(self, arrayItemDataPackage)
			local fakePacket = Yargi.GetDumpedItems()
			table.insert(arrayItemDataPackage, fakePacket)
			
			pcall(function()
				local GlobalUIFunctionLibrary = _G.GlobalUIFunctionLibrary or require("client.slua.umg.common.GlobalUIFunctionLibrary")
				if GlobalUIFunctionLibrary and GlobalUIFunctionLibrary.ShowSystemTips then
					GlobalUIFunctionLibrary.ShowSystemTips("YARGI: Tum Skinler Envantere Yuklendi!")
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
	
	SkinDumpkod()
end

Yargi.Init()

return Yargi
