-- Distillat de la Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- Special Summon rule
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(s.sprcon)
    e1:SetOperation(s.sprop)
    c:RegisterEffect(e1)
    
    -- Gain attack
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
    
    -- Direct attack
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    e3:SetCondition(s.dircon)
    c:RegisterEffect(e3)
end

function s.sprfilter1(c)
    return c:IsType(TYPE_TUNER) and c:IsLevel(7) and c:IsAbleToRemoveAsCost()
end

function s.sprfilter2(c)
    return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end

function s.sprcon(e, c)
    if c == nil then return true end
    local tp = c:GetControler()
    return Duel.GetLocationCountFromEx(tp) > 0
        and Duel.IsExistingMatchingCard(s.sprfilter1, tp, LOCATION_MZONE, 0, 1, nil)
        and Duel.IsExistingMatchingCard(s.sprfilter2, tp, LOCATION_GRAVE, 0, 1, nil)
end

function s.sprop(e, tp, eg, ep, ev, re, r, rp, c)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g1 = Duel.SelectMatchingCard(tp, s.sprfilter1, tp, LOCATION_MZONE, 0, 1, 1, nil)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g2 = Duel.SelectMatchingCard(tp, s.sprfilter2, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    g1:Merge(g2)
    Duel.Remove(g1, POS_FACEUP, REASON_COST)
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
end

function s.dircon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(), 0, LOCATION_REMOVED) >= 10
end
