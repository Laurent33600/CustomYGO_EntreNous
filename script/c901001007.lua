-- Cristal de la Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- Synchro Summon
    c:EnableReviveLimit()
    aux.AddSynchroProcedure(c, aux.FilterBoolFunction(Card.IsType, TYPE_TUNER), aux.NonTuner(Card.IsType, TYPE_SYNCHRO), 1)
    
    -- Shuffle banished traps and banish opponent's GY cards
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TODECK + CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.filter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and c:IsAbleToDeck()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_REMOVED, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 0, tp, LOCATION_REMOVED)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 0, 1 - tp, LOCATION_GRAVE)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_REMOVED, 0, 1, 99, nil)
    if #g > 0 then
        Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        local ct = #g
        Duel.Hint(HINT_SELECTMSG, 1 - tp, HINTMSG_REMOVE)
        local rg = Duel.SelectMatchingCard(1 - tp, aux.NecroValleyFilter(Card.IsAbleToRemove), tp, 0, LOCATION_GRAVE, ct, ct, nil)
        if #rg > 0 then
            Duel.Remove(rg, POS_FACEUP, REASON_EFFECT)
        end
    end
end
