function Player:onBrowseField(position)
	return true
end

function Player:onLook(thing, position, distance)
	local description = "You see " .. thing:getDescription(distance)
	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItemID: [%d]", description, thing:getId())

			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, ActionID: [%d]", description, actionId)
			end
			
			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, UniqueId: [%d]", description, uniqueId)
			end
			
			description = description .. "."
			local itemType = thing:getType()
			
			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransformTo: [%d] (onEquip).", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransformTo: [%d] (onDeEquip).", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecayTo: [%d]", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: [%d / %d]"
			if thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: [%d / %d]", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end
		
		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: [X: %d] [Y: %d] [Z: %d].",
			description, position.x, position.y, position.z
		)
		
		if thing:isCreature() then
			if thing:isPlayer() then
				description = string.format("%s\nIP: [%s].", description, Game.convertIpToString(thing:getIp()))
			end
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = "You see " .. creature:getDescription(distance)
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: [%d / %d]"
		if creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: [%d / %d]", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
			"%s\nPosition: [X: %d] [Y: %d] [Z: %d].",
			description, position.x, position.y, position.z
		)
		
		if creature:isPlayer() then
			description = string.format("%s\nIP: [%s].", description, Game.convertIpToString(creature:getIp()))
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(MESSAGE_INFO_DESCR, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition)
	return true
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	return true
end

function Player:onTurn(direction)
	return true
end

function Player:onTradeRequest(target, item)
	return true
end

function Player:onGainExperience(target, exp, rawExp)
	return exp
end

function Player:onLoseExperience(exp)
	return exp
end

local firstItems = {2050, 2382}
function Player:onLogin()
	local loginStr = "Welcome to " .. configManager.getString(configKeys.SERVER_NAME) .. "!"
	if self:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. " Please choose your outfit."
		self:sendOutfitWindow()
	else
		if loginStr ~= "" then
			self:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format("Your last visit was on %s.", os.date("%a %b %d %X %Y", self:getLastLoginSaved()))
	end
	self:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
	if self:getLastLoginSaved() == 0 then
		for i = 1, #firstItems do
			self:addItem(firstItems[i], 1)
		end
		self:addItem(self:getSex() == 0 and 2651 or 2650, 1)
		self:addItem(1987, 1):addItem(2674, 1)
	end
	return true
end

function Player:onLogout()
	return true
end

function Player:onAdvance(skill, oldLevel, newLevel)
	return true
end

function Player:onModalWindow(modalWindowId, buttonId, choiceId)
end

function Player:onTextEdit(item, text)
	return true
end

local OPCODE_LANGUAGE = 1
function Player:onExtendedOpcode(opcode, buffer)
	if opcode == OPCODE_LANGUAGE then
		-- otclient language
		if buffer == 'en' or buffer == 'pt' then
			-- example, setting player language, because otclient is multi-language...
			-- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
		end
	else
		-- other opcodes can be ignored, and the server will just work fine...
	end
end
