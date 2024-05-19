-- Soupçon de la Fiole Disparue
local s,id=GetID()

function s.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and Duel.IsMainPhase())
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)~=0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local options = {
		[1] = {desc = aux.Stringid(id,1), func = s.addToHand},
		[2] = {desc = aux.Stringid(id,2), func = s.banish},
		[3] = {desc = aux.Stringid(id,3), func = nil} -- Cancel option
	}

	local optionText = ""
	for i, option in ipairs(options) do
		optionText = optionText .. "[" .. i .. "] " .. option.desc .. "\n"
	end

	local selectedOption = Duel.SelectOption(tp,table.unpack(optionText))

	if selectedOption == 3 then return end -- Cancel option

	options[selectedOption].func(e,tp)
end

function s.addToHand(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

function s.banish(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToRemove() then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

function s.filter(c)
	return c:IsSetCard(3856) and c:IsType(TYPE_TRAP)
end

function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
