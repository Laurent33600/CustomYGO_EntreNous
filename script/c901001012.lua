-- Fumerolle de la Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- Synchro summon
    Synchro.AddProcedure(c, nil, 1, 1, Synchro.NonTuner(nil), 1, 99)
    c:EnableReviveLimit()
    -- Banish opponent's monsters
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TODECK + CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(s.bancon)
    e1:SetTarget(s.bantg)
    e1:SetOperation(s.banop)
    c:RegisterEffect(e1)
end

function s.bancon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.filter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and c:IsAbleToDeck()
end

function s.bantg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_REMOVED, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_REMOVED)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, 1-tp, LOCATION_MZONE)
end

function s.banop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_REMOVED, 0, 1, 3, nil)
    if #g > 0 then
        Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
        local ct = #g
        if ct > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
            local sg = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(Card.IsAbleToRemove), tp, 0, LOCATION_MZONE, ct, ct, nil)
            if #sg > 0 then
                Duel.Remove(sg, POS_FACEUP, REASON_EFFECT)
            end
        end
    end
end
