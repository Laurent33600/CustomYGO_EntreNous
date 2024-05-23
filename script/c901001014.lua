-- La Fiole Disparue
local s, id = GetID()

function s.initial_effect(c)
    -- You can only control 1 "La Fiole Disparue"
    c:SetUniqueOnField(1, 0, id)
    
    -- Banish card from Deck when a "Fiole Disparue" card banishes a card
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_REMOVE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(s.rmcon)
    e1:SetTarget(s.rmtg)
    e1:SetOperation(s.rmop)
    c:RegisterEffect(e1)
    
    -- Return card to Deck
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.tdtg)
    e2:SetOperation(s.tdop)
    c:RegisterEffect(e2)
    
    -- Banish all cards from Graveyard when this card is banished
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetCondition(s.gravecon)
    e3:SetOperation(s.graveop)
    c:RegisterEffect(e3)
end

function s.cfilter(c)
    return c:IsSetCard(3856) and c:IsFaceup()
end

function s.rmcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.cfilter, 1, nil) and not re:GetHandler():IsCode(id)
end

function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanRemove(tp) end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_DECK)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
    local opt = Duel.SelectOption(tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
    if opt == 0 then
        Duel.Remove(Duel.GetDecktopGroup(tp, 1), POS_FACEUP, REASON_EFFECT)
    else
        Duel.Remove(Duel.GetDecktopGroup(1 - tp, 1), POS_FACEUP, REASON_EFFECT)
    end
end

function s.tdfilter(c)
    return c:IsSetCard(3856) and (c:IsAbleToDeck() or c:IsAbleToExtra())
end

function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_REMOVED + LOCATION_GRAVE, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_REMOVED + LOCATION_GRAVE)
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectMatchingCard(tp, s.tdfilter, tp, LOCATION_REMOVED + LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
    end
end

function s.gravecon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.graveop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(tp, LOCATION_GRAVE, 0)
    Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
end
