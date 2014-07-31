/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2014  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef FS_EVENTS_H_BD444CC0EE167E5777E4C90C766B36DC
#define FS_EVENTS_H_BD444CC0EE167E5777E4C90C766B36DC

#include "luascript.h"

class Party;
class ItemType;

class Events
{
	public:
		Events();
		~Events() {}

		void clear();
		bool load();

		// Party
		bool eventPartyOnJoin(Party* party, Player* player);
		bool eventPartyOnLeave(Party* party, Player* player);
		bool eventPartyOnDisband(Party* party);

		// Player
		bool eventPlayerOnBrowseField(Player* player, const Position& position);
		void eventPlayerOnLook(Player* player, const Position& position, Thing* thing, uint8_t stackpos, int32_t lookDistance);
		void eventPlayerOnLookInBattleList(Player* player, Creature* creature, int32_t lookDistance);
		void eventPlayerOnLookInTrade(Player* player, Player* partner, Item* item, int32_t lookDistance);
		bool eventPlayerOnLookInShop(Player* player, const ItemType* itemType, uint8_t count);
		bool eventPlayerOnMoveItem(Player* player, Item* item, uint16_t count, const Position& fromPosition, const Position& toPosition);
		bool eventPlayerOnMoveCreature(Player* player, Creature* creature, const Position& fromPosition, const Position& toPosition);
		bool eventPlayerOnTurn(Player* player, Direction direction);
		bool eventPlayerOnTradeRequest(Player* player, Player* target, Item* item);
		bool eventPlayerOnGainExperience(Player* player, Creature* target, uint64_t &exp, uint64_t rawExp);
		bool eventPlayerOnLoseExperience(Player* player, uint64_t &exp);
		bool eventPlayerOnLogin(Player* player);
		bool eventPlayerOnLogout(Player* player);
		bool eventPlayerOnAdvance(Player* player, skills_t, uint32_t, uint32_t);
		void eventPlayerOnModalWindow(Player* player, uint32_t modalWindowId, uint8_t buttonId, uint8_t choiceId);
		bool eventPlayerOnTextEdit(Player* player, Item* item, const std::string& text);
		void eventPlayerOnExtendedOpcode(Player* player, uint8_t opcode, const std::string& buffer);

		// Creature
		bool eventCreatureOnTarget(Creature* creature, Creature* target, bool isAttacked);
		bool eventCreatureOnChangeOutfit(Creature* creature, const Outfit_t outfit, const Outfit_t oldOutfit);
		bool eventCreatureOnAttack(Creature* creature, Creature* target);
		void eventCreatureOnHear(Creature* creature, Creature* sayCreature, const std::string words, enum SpeakClasses type, Position pos);
		bool eventCreatureOnThink(Creature* creature, uint32_t interval);
		bool eventCreatureOnPrepareDeath(Creature* creature, Creature* killer);
		bool eventCreatureOnDeath(Creature* creature, Item* corpse, Creature* killer, Creature* mostDamageKiller, bool lastHitUnjustified, bool mostDamageUnjustified);
		bool eventCreatureOnKill(Creature* creature, Creature* target);
		void eventCreatureOnChangeHealth(Creature* creature, Creature* attacker, CombatDamage& damage);
		void eventCreatureOnChangeMana(Creature* creature, Creature* attacker, int32_t& manaChange, CombatOrigin origin);

		// Monster
		void eventMonsterOnTargetDeny(Creature* creature, Creature* target);
		bool eventMonsterOnAppear(Creature* creature);
		bool eventMonsterOnDisappear(Creature* creature);

	private:
		LuaScriptInterface scriptInterface;

		// Party
		int32_t partyOnJoin;
		int32_t partyOnLeave;
		int32_t partyOnDisband;

		// Player
		int32_t playerOnBrowseField;
		int32_t playerOnLook;
		int32_t playerOnLookInBattleList;
		int32_t playerOnLookInTrade;
		int32_t playerOnLookInShop;
		int32_t playerOnMoveItem;
		int32_t playerOnMoveCreature;
		int32_t playerOnTurn;
		int32_t playerOnTradeRequest;
		int32_t playerOnGainExperience;
		int32_t playerOnLoseExperience;
		int32_t playerOnLogin;
		int32_t playerOnLogout;
		int32_t playerOnAdvance;
		int32_t playerOnModalWindow;
		int32_t playerOnTextEdit;
		int32_t playerOnExtendedOpcode;

		// Creature
		int32_t creatureOnTarget;
		int32_t creatureOnChangeOutfit;
		int32_t creatureOnAttack;
		int32_t creatureOnHear;
		int32_t creatureOnThink;
		int32_t creatureOnPrepareDeath;
		int32_t creatureOnDeath;
		int32_t creatureOnKill;
		int32_t creatureOnChangeHealth;
		int32_t creatureOnChangeMana;


		// Monster
		int32_t monsterOnTargetDeny;
		int32_t monsterOnAppear;
		int32_t monsterOnDisappear;
};

#endif
