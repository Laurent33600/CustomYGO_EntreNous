-- Catalyseur de la Fiole Disparue
-- Scripted by [Your Name or Username]

local s,id=GetID()
function s.initial_effect(c)
    -- Special Summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- Activate Trap from Deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id)
    e2:SetTarget(s.actg)
    e2:SetOperation(s.acop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end

function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end

function s.filter(c)
    return c:IsSetCard(0xf10) and c:IsType(TYPE_TRAP) and c:CheckActivateEffect(false,false,false)~=nil
end

function s.acop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
        local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            local te=tc:GetActivateEffect()
            if te then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                e1:SetCode(EVENT_CHAIN_SOLVED)
                e1:SetLabelObject(te)
                e1:SetOperation(s.activate)
                Duel.RegisterEffect(e1,tp)
                Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
                Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
                tc:CreateEffectRelation(te)
                te:UseCountLimit(tp,1,true)
            end
        end
    end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    local tc=te:GetHandler()
    if te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc then
        Duel.Activate(te)
    end
    e:Reset()
end
