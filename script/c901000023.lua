-- Soupçon de la Fiole Disparue
local s,id=GetID()
function s.initial_effect(c)
    -- Activate effect upon normal summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetTurnPlayer()==tp and e:GetHandler():IsRelateToEffect(e) end
    
    local options = {
        [1] = {desc = aux.Stringid(id,1), func = s.addToHand},
        [2] = {desc = aux.Stringid(id,2), func = s.banish}
    }

    local optionText = ""
    for i, option in ipairs(options) do
        optionText = optionText .. "[" .. i .. "] " .. option.desc .. "\n"
    end

    local selectedOption = Duel.SelectOption(tp,table.unpack(optionText))

    options[selectedOption+1].func(e,tp)
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
