-- Soupçon de la Fiole Disparue
local s,id=GetID()
function s.initial_effect(c)
    -- Search or Banish
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToRemove())
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local op=0
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if op==0 then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        end
    end
end
