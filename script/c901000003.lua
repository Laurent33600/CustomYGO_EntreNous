-- Atelier de la Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- Activate the turn it was set
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetCondition(s.actcon)
    c:RegisterEffect(e1)
    
    -- Gain or lose levels
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_LVCHANGE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1, id)
    e2:SetTarget(s.lvtg)
    e2:SetOperation(s.lvop)
    c:RegisterEffect(e2)
    
    -- Draw a card if banished
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCountLimit(1, id + 1)
    e3:SetTarget(s.drtg)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
end

function s.actcon(e)
    return Duel.GetMatchingGroupCount(Card.IsType, e:GetHandlerPlayer(), LOCATION_GRAVE, 0, nil, TYPE_TRAP) == 0
end

function s.lvtg(e, tp, eg, ep, ev, re, r, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk == 0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, nil) and Duel.GetFieldGroupCount(tp, LOCATION_REMOVED, 0) > 0 end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_LVCHANGE, nil, 1, tp, LOCATION_MZONE)
end

function s.lvop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, LOCATION_REMOVED, 0, 1, 99, nil)
        if #g > 0 then
            Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
            local ct = #g
            if ct > 0 then
                Duel.BreakEffect()
                local opt = Duel.SelectOption(tp, aux.Stringid(id, 2), aux.Stringid(id, 3))
                if opt == 0 then
                    Duel.UpdateLevel(tc, ct)
                else
                    Duel.UpdateLevel(tc, -ct)
                end
            end
        end
    end
end

function s.drtg(e, tp, eg, ep, ev, re, r, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end
