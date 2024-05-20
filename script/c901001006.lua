-- Chaudron de la Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- Draw when cards are banished
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_REMOVE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.drcon)
    e1:SetTarget(s.drtg)
    e1:SetOperation(s.drop)
    c:RegisterEffect(e1)

    -- Draw when this card is banished
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1, id + 1)
    e2:SetTarget(s.drtg2)
    e2:SetOperation(s.drop2)
    c:RegisterEffect(e2)
end

function s.cfilter(c)
    return c:IsType(TYPE_SPELL + TYPE_TRAP + TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA)
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.cfilter, 1, nil)
end

function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 2) end
    local ct = math.min(2, eg:FilterCount(s.cfilter, nil))
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, ct)
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end

function s.drtg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.drop2(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end
