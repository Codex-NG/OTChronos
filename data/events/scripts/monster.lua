function Monster:onTargetDeny(target)
end

function Monster:onAppear()
	if self:isPlayer() then
		print("works")
	end
	if self:isMonster() then
		if not isInArray(monsters, self:getName(),true) then
			monsters[self:getName()] = {}
			monsters[self:getName()][1] = cid
		else
			monsters[self:getName()][#monsters == nil and 1 or #monsters[self:getName()]+1] = cid
		end
	end
	return true
end

function Monster:onDisappear()
	print("Monster:onDisappear works")
	if self:isMonster() then
		for i = 1, #monsters[self:getName()] do
			if monsters[self:getName()][i] == cid then
				table.remove(monsters[self:getName()], i)
				break
			end
		end
		table.sort(monsters[self:getName()])
	end
	return true
end