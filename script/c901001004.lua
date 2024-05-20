-- Bouclier de la Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- Activate the turn it was set
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetCondition(s.actcon)
    c:RegisterEffect(e1)
    
    -- Indestructible effect
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1, id)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
    
    -- Send to graveyard if banished
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1, id + 1)
    e3:SetTarget(s.grtg)
    e3:SetOperation(s.grop)
    c:RegisterEffect(e3)
end

function s.actcon(e)
    return Duel.GetMatchingGroupCount(Card.IsType, e:GetHandlerPlayer(), LOCATION_GRAVE, 0, nil, TYPE_TRAP) == 0
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
    local tc = g:GetFirst()
    while tc do
        if tc:IsSetCard(3856) and tc:IsType(TYPE_SYNCHRO) then
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
            e1:SetValue(1)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
            tc:RegisterEffect(e1)
            local e2 = Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
            e2:SetValue(1)
            e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
            tc:RegisterEffect(e2)
        end
        tc = g:GetNext()
    end
end

function s.grtg(e, tp, eg, ep, ev, re, r, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.grfilter, tp, LOCATION_DECK, 0, 1, nil) end
end

function s.grfilter(c)
    return c:IsCode(id) and c:IsAbleToGrave()
end

function s.grop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.grfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoGrave(g, REASON_EFFECT)
    end
end
