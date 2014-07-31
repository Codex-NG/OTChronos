local Register = 
{
	target = {},
	outfit = {},
	attack = {},
	hear = {},
	think = {},
	prepareDeath = {}
}

local UnRegister =
{
	target = {},
	outfit = {},
	attack = {},
	hear = {},
	think = {},
	prepareDeath = {}
}

-- I use this method to register and un register certain monsters / npcs / players if you leave both tables empty all are registered.
-- example target = {} in both register and unRegister table.
-- IMPORTANT names must be lower case example: Demon has to be demon or Evil Hero has to be evil hero.
-- to enable it for all players / monsters /npcs use "all players" "all monsters" "all npcs"
function register(self, registerTable)
	if registerTable[1] ~= nil then
		if self:isPlayer() and not isInArray(registerTable, "all players") then
			if not isInArray(registerTable, string.lower(self:getName())) then
				return false
			end
		elseif self:isMonster() and not isInArray(registerTable, "all monsters") then
			if not isInArray(registerTable, string.lower(self:getName())) then
				return false
			end
		elseif self:isNpc() and not isInArray(registerTable, "all npcs") then
			if not isInArray(registerTable, string.lower(self:getName())) then
				return false
			end
		end
	end
	return true
end

function unRegister(self, unRegisterTable)
	if unRegisterTable[1] ~= nil then
		if isInArray(unRegisterTable, string.lower(self:getName())) then
			return true
		end
	end
	return false
end
-- functions end here, please do not edit them!


-- Events start from here on!
function Creature:onTarget(target, isAttacked)
	if not register(self, Register.target) then
		return true
	end
	if unRegister(self, UnRegister.target) then
		return true
	end
	-- start scripting from here on.
	return true
end

function Creature:onChangeOutfit(newOutfit, oldOutfit)
	if not register(self, Register.outfit) then
		return true
	end
	if unRegister(self, UnRegister.outfit) then
		return true
	end
	-- return true so the player is able to change his outfit or return false and the old outfit will stay.
	-- start scripting from here on.
	return true
end

function Creature:onAttack(target)
	if not register(self, Register.attack) then
		return true
	end
	if unRegister(self, UnRegister.attack) then
		return true
	end
	-- return true and the monster / player / npc can do dmg again.
	-- start scripting from here on.
	return true
end

function Creature:onHear(sayCreature, words, type, pos)
	if not register(self, Register.hear) then
		return true
	end
	if unRegister(self, UnRegister.hear) then
		return true
	end
	-- doesn't need a return value.
	-- start scripting from here on.
end

function Creature:onThink(interval)
	if not register(self, Register.think) then
		return true
	end
	if unRegister(self, UnRegister.think) then
		return true
	end
	-- start scripting from here on.
	return true
end

function Creature:onPrepareDeath(killer)
	if not register(self, Register.prepareDeath) then
		return true
	end
	if unRegister(self, UnRegister.prepareDeath) then
		return true
	end
	-- start scripting from here on.
	return true
end

local deathListEnabled = true
local maxDeathRecords = 5
function Creature:onDeath(corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not self:isPlayer() then
		return true
	end
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are dead.")
	if not deathListEnabled then
		return
	end

	local byPlayer = 0
	if killer == nil then
		killerName = "field item"
	else
		if killer:isPlayer() then
			byPlayer = 1
		else
			local master = killer:getMaster()
			if master and master ~= killer and master:isPlayer() then
				killer = master
				byPlayer = 1
			end
		end
		killerName = killer:getName()
	end

	local byPlayerMostDamage = 0
	if mostDamage == 0 then
		mostDamageName = "field item"
	else
		if mostDamage:isPlayer() then
			byPlayerMostDamage = 1
		else
			local master = mostDamage:getMaster()
			if master and master ~= mostDamage and master:isPlayer() then
				mostDamage = master
				byPlayerMostDamage = 1
			end
		end
		mostDamageName = mostDamage:getName()
	end

	local playerGuid = self:getGuid()
	db.query("INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES (" .. playerGuid .. ", " .. os.time() .. ", " .. self:getLevel() .. ", " .. db.escapeString(killerName) .. ", " .. byPlayer .. ", " .. db.escapeString(mostDamageName) .. ", " .. byPlayerMostDamage .. ", " .. unjustified .. ", " .. mostDamage_unjustified .. ")")
	local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGuid)

	local deathRecords = 0
	local tmpResultId = resultId
	while tmpResultId ~= false do
		tmpResultId = result.next(resultId)
		deathRecords = deathRecords + 1
	end

	if resultId ~= false then
		result.free(resultId)
	end

	while deathRecords > maxDeathRecords do
		db.query("DELETE FROM `player_deaths` WHERE `player_id` = " .. playerGuid .. " ORDER BY `time` LIMIT 1")
		deathRecords = deathRecords - 1
	end

	if byPlayer == 1 then
		local guild = self:getGuild()
		local targetGuild = guild and guild:getId()
		if targetGuild ~= 0 then
			local killerGuild = killer:getGuild():getId()
			if killerGuild ~= 0 and targetGuild ~= killerGuild and isInWar(cid, killer) then
				local warId = false
				resultId = db.storeQuery("SELECT `id` FROM `guild_wars` WHERE `status` = 1 AND ((`guild1` = " .. killerGuild .. " AND `guild2` = " .. targetGuild .. ") OR (`guild1` = " .. targetGuild .. " AND `guild2` = " .. killerGuild .. "))")
				if resultId ~= false then
					warId = result.getDataInt(resultId, "id")
					result.free(resultId)
				end

				if warId ~= false then
					db.query("INSERT INTO `guildwar_kills` (`killer`, `target`, `killerguild`, `targetguild`, `time`, `warid`) VALUES (" .. db.escapeString(killerName) .. ", " .. db.escapeString(self:getName()) .. ", " .. killerGuild .. ", " .. targetGuild .. ", " .. os.time() .. ", " .. warId .. ")")
				end
			end
		end
	end
end

function Creature:onKill(target)
	return true
end

function Creature:onChangeHealth(attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function Creature:onChangeMana(attacker, manaChange, origin)
	return -manaChange
end


	