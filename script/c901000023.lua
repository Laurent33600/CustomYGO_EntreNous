-- Soupçon de la Fiole Disparue
local s,id=GetID()

function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:SetCategory(CATEGORY_TOHAND)
    e:SetOperation(s.addToHand)
end

function s.addToHand(e,tp,eg,ep,ev,re,r,rp)
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

function s.filter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
