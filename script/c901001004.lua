-- Bouclier de la Fiole Disparue
-- Scripted by [Your Name or Username]

local s, id = GetID()

function s.initial_effect(c)
    -- Activate the turn it was set
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetCondition(s.actcon)
    c:RegisterEffect(e1)
    
     -- Synchro Monsters "Fiole Disparue" cannot be destroyed by card effects
     local e2=Effect.CreateEffect(c)
     e2:SetType(EFFECT_TYPE_FIELD)
     e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
     e2:SetRange(LOCATION_MZONE)
     e2:SetTargetRange(LOCATION_MZONE,0)
     e2:SetTarget(s.operation)
     e2:SetValue(1)
     e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
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

function s.operation(e, c)
    return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xf10) -- 0xf10 is the hexadecimal for 3856
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
