-- Fumée de la Fiole Disparue
-- Scripted by [Your Name or Username]

local s, id = GetID()

function s.initial_effect(c)
    -- Synchro summon
    Synchro.AddProcedure(c, nil, 1, 1, Synchro.NonTuner(nil), 1, 99)
    c:EnableReviveLimit()
    -- Special Summon rule
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(s.sprcon)
    e1:SetOperation(s.sprop)
    c:RegisterEffect(e1)
    -- ATK reduction
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(s.atkcon)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end

function s.sprfilter1(c)
    return c:IsLevel(5) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end

function s.sprfilter2(c)
    return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end

function s.sprcon(e, c)
    if c == nil then return true end
    return Duel.IsExistingMatchingCard(s.sprfilter1, c:GetControler(), LOCATION_MZONE, 0, 1, nil)
        and Duel.IsExistingMatchingCard(s.sprfilter2, c:GetControler(), LOCATION_GRAVE, 0, 1, nil)
end

function s.sprop(e, tp, eg, ep, ev, re, r, rp, c)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g1 = Duel.SelectMatchingCard(tp, s.sprfilter1, tp, LOCATION_MZONE, 0, 1, 1, nil)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g2 = Duel.SelectMatchingCard(tp, s.sprfilter2, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    g1:Merge(g2)
    Duel.Remove(g1, POS_FACEUP, REASON_COST)
end

function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end

function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_GRAVE)
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 and Duel.Remove(g, POS_FACEUP, REASON_EFFECT) > 0 then
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetTargetRange(0, LOCATION_MZONE)
        e1:SetValue(-300)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
end
