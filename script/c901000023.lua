-- Soupcon de la Fiole Disparue
-- Scripted by [Your Name or Username]

local s, id = GetID()

function s.initial_effect(c)
    -- When this card is Normal Summoned: add 1 "Fiole Disparue" Trap Card from your Deck to your hand, or banish it.
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_REMOVE + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToRemove())
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_DECK)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        local tc = g:GetFirst()
        local b1 = tc:IsAbleToHand()
        local b2 = tc:IsAbleToRemove()
        local op = 0
        if b1 and b2 then
            op = Duel.SelectOption(tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
        elseif b1 then
            op = Duel.SelectOption(tp, aux.Stringid(id, 0))
        elseif b2 then
            op = Duel.SelectOption(tp, aux.Stringid(id, 1)) + 1
        else
            return
        end
        if op == 0 then
            Duel.SendtoHand(tc, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, tc)
        else
            Duel.Remove(tc, POS_FACEUP, REASON_EFFECT)
        end
    end
end
