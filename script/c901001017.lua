-- Pouvoir de la Fiole Disparue
-- Scripted by [Your Name or Username]

local s,id=GetID()
function s.initial_effect(c)
    -- Always treated as "la Source Sombre"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_SZONE+LOCATION_FZONE+LOCATION_PZONE+LOCATION_REMOVED)
    e0:SetCode(EFFECT_ADD_SETCODE)
    e0:SetValue(0x3857)
    c:RegisterEffect(e0)
    -- Fusion summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.fusiontg)
    e1:SetOperation(s.fusionop)
    c:RegisterEffect(e1)
    -- Xyz summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.xyztg)
    e2:SetOperation(s.xyzop)
    c:RegisterEffect(e2)
end

function s.filter0(c)
    return c:IsOnField() and c:IsAbleToRemove()
end

function s.filter1(c,e)
    return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end

function s.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3856) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function s.fusiontg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter0,nil)
        local mg2=Duel.GetMatchingGroup(s.filter0,tp,0,LOCATION_GRAVE,nil)
        mg1:Merge(mg2)
        return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.fusionop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
    local mg2=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_GRAVE,nil,e)
    mg1:Merge(mg2)
    local sg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    if #sg>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=sg:Select(tp,1,1,nil):GetFirst()
        local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
        tc:SetMaterial(mat)
        Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_FUSION+REASON_MATERIAL)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end

function s.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end

function s.xyzfilter(c,e,tp,lv)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0x3857) and c:GetRank()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
        return Duel.GetLocationCountFromEx(tp)>0
            and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,1)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=rg:Select(tp,1,rg:GetCount(),nil)
    local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    if ct>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
        if tc then
            local rk=tc:GetRank()+ct
            local sg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,rk)
            if #sg>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local xyz=sg:Select(tp,1,1,nil):GetFirst()
                if Duel.SpecialSummon(xyz,0,tp,tp,false,false,POS_FACEUP)~=0 then
                    Duel.Overlay(xyz,Group.FromCards(tc))
                end
            end
        end
    end
end
