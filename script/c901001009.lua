-- Ectoplasme de la Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- Special Summon itself
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    
    -- Set Trap and become Tuner
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_LEAVE_GRAVE + CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(s.settg)
    e2:SetOperation(s.setop)
    c:RegisterEffect(e2)
end

function s.spfilter(c)
    return c:IsSetCard(3856) and c:IsFaceup()
end

function s.spcon(e, c)
    if c == nil then return true end
    return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
        and Duel.GetMatchingGroupCount(s.spfilter, c:GetControler(), LOCATION_REMOVED, 0, nil) >= 3
end

function s.setfilter(c)
    return c:IsSetCard(3856) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_GRAVE, 0, 1, nil) end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
    local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SSet(tp, g)
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetValue(TYPE_TUNER)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end
