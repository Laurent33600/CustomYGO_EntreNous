-- Soupcon de la Fiole Disparue
-- Scripted by [Your Name or Username]

local s, id = GetID()

-- Define functions for "Soupcon de la Fiole Disparue"
function s.initial_effect(c)
    -- Add "Fiole Disparue" archetype setcode
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ADD_SETCODE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(3856)
    c:RegisterEffect(e1)

    -- Effect 1: When this card is Normal Summoned: add 1 "Fiole Disparue" Trap Card from your Deck to your hand, or banish it.
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,id)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end

-- Effect 1: Target and operation functions
function s.thfilter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    local sel=0
    if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
        sel=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
    else
        sel=Duel.SelectOption(tp,aux.Stringid(id,2))+1
    end
    e:SetLabel(sel)
    if sel==0 then
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    else
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
    end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local sel=e:GetLabel()
    if sel==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
    end
end